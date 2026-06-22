using Stripe;
using System.Text.Json;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Helpers;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Service
{
  public class PaymentService(IUnitOfWork uow, IBookingService bookingService) : IPaymentService
  {
    private readonly IUnitOfWork _uow = uow;
    private readonly IBookingService _bookingService = bookingService;

    private static string ComputeSeatHash(IEnumerable<SeatDto> seats)
    {
      return string.Join(",", seats
          .OrderBy(s => s.Row).ThenBy(s => s.SeatNumber)
          .Select(s => $"{s.Row}:{s.SeatNumber}"));
    }

    public async Task<BookingResultDto> ConfirmAsync(string paymentIntentId, string userId, CancellationToken ct = default)
    {
      var service = new PaymentIntentService();
      var paymentIntent = await service.GetAsync(paymentIntentId, cancellationToken: ct);

      if (paymentIntent.Status != "succeeded")
        return BookingResultDto.Failure("Payment has not been completed.");

      if (paymentIntent.Metadata["userId"] != userId)
        return BookingResultDto.Failure("Unauthorized access.");

      var showtimeId = int.Parse(paymentIntent.Metadata["showtimeId"]);
      var seats = JsonSerializer.Deserialize<List<SeatDto>>(paymentIntent.Metadata["seats"])!;

      var bookingDto = new BookingCreateDto { ShowtimeId = showtimeId, Seats = seats };
      var result = await _bookingService.CreateAsync(bookingDto, userId, ct);

      var payment = await _uow.Payments.GetAsync(p => p.StripePaymentIntentId == paymentIntentId);

      if (!result.Succeeded && result.ConflictingSeats.Count > 0)
      {
        var refundService = new RefundService();
        await refundService.CreateAsync(
            new RefundCreateOptions { PaymentIntent = paymentIntentId },
            cancellationToken: ct
          );

        if (payment is not null)
        {
          payment.Status = PaymentStatus.Refunded;
          payment.RefundedAt = DateTime.UtcNow;
          await _uow.SaveAsync();
        }
      }
      else if (result.Succeeded && payment is not null)
      {
        payment.Status = PaymentStatus.Completed;
        payment.CompletedAt = DateTime.UtcNow;
        await _uow.SaveAsync();
      }

      return result;
    }

    public async Task<PaymentIntentResultDto> CreateIntentAsync(CreatePaymentIntentDto dto, string userId, CancellationToken ct = default)
    {
      var spec = new ShowtimeByIdSpecification(dto.ShowtimeId);
      var showtime = await _uow.Showtimes.GetEntityWithSpecAsync(spec);
      if (showtime is null) return null;

      var template = HallTypeHelper.GetTemplate(showtime.Hall.Type);
      dto.Seats = dto.Seats.OrderBy(s => s.Row).ThenBy(s => s.SeatNumber).ToList();
      var seatHash = ComputeSeatHash(dto.Seats);

      var dedupSpec = new PaymentSpecification(userId, dto.ShowtimeId, seatHash);
      var existing = await _uow.Payments.GetEntityWithSpecAsync(dedupSpec, ct);
      if (existing is not null)
      {
        return new PaymentIntentResultDto
        {
          ClientSecret = existing.ClientSecret,
          PaymentIntentId = existing.StripePaymentIntentId,
          TotalAmount = existing.TotalAmount
        };
      }

      decimal totalAmount = 0;
      var paymentSeats = new List<PaymentSeat>();
      foreach (var seat in dto.Seats)
      {
        var category = template.RowCategoryMap[seat.Row];
        var multiplier = HallTypeHelper.GetPriceMultiplier(category);
        var unitPrice = showtime.Price * multiplier;
        totalAmount += unitPrice;
        paymentSeats.Add(new PaymentSeat { Row = seat.Row, SeatNumber = seat.SeatNumber, UnitPrice = unitPrice });
      }

      var metaData = new Dictionary<string, string>
      {
        ["userId"] = userId,
        ["showtimeId"] = dto.ShowtimeId.ToString(),
        ["seats"] = JsonSerializer.Serialize(dto.Seats)
      };

      var options = new PaymentIntentCreateOptions
      {
        Amount = (long)(totalAmount * 100),
        Currency = "AED",
        Metadata = metaData,
        AutomaticPaymentMethods = new PaymentIntentAutomaticPaymentMethodsOptions
        {
          Enabled = true,
        },
      };

      var requestOptions = new RequestOptions
      {
        IdempotencyKey = Guid.NewGuid().ToString("N")
      };

      var service = new PaymentIntentService();
      var paymnetIntent = await service.CreateAsync(options, requestOptions, ct);

      var payment = new Payment
      {
        StripePaymentIntentId = paymnetIntent.Id,
        ClientSecret = paymnetIntent.ClientSecret,
        UserId = userId,
        ShowtimeId = dto.ShowtimeId,
        TotalAmount = totalAmount,
        Currency = "AED",
        Status = PaymentStatus.Pending,
        SeatHash = seatHash,
        SeatCount = dto.Seats.Count,
        CreatedAt = DateTime.UtcNow,
        PaymentSeats = paymentSeats
      };

      await _uow.Payments.CreateAsync(payment);
      await _uow.SaveAsync();

      return new PaymentIntentResultDto
      {
        ClientSecret = paymnetIntent.ClientSecret,
        PaymentIntentId = paymnetIntent.Id,
        TotalAmount = totalAmount
      };
    }
  }
}
