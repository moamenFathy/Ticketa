using Stripe;
using System.Text.Json;
using Ticketa.Core.DTOs;
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

      if (!result.Succeeded && result.ConflictingSeats.Count > 0)
      {
        var refundService = new RefundService();
        await refundService.CreateAsync(
            new RefundCreateOptions { PaymentIntent = paymentIntentId },
            cancellationToken: ct
          );
      }

      return result;
    }

    public async Task<PaymentIntentResultDto> CreateIntentAsync(CreatePaymentIntentDto dto, string userId, CancellationToken ct = default)
    {
      var spec = new ShowtimeByIdSpecification(dto.ShowtimeId);
      var showtime = await _uow.Showtimes.GetEntityWithSpecAsync(spec);
      if (showtime is null) return null;

      var template = HallTypeHelper.GetTemplate(showtime.Hall.Type);


      var totalAmount = dto.Seats.Sum(seat =>
      {
        var category = template.RowCategoryMap[seat.Row];
        decimal multiplier = HallTypeHelper.GetPriceMultiplier(category);

        return showtime.Price * multiplier;
      });

      var metaData = new Dictionary<string, string>
      {
        ["userId"] = userId,
        ["showtimeId"] = dto.ShowtimeId.ToString(),
        ["seats"] = JsonSerializer.Serialize(dto.Seats)
      };

      var options = new PaymentIntentCreateOptions
      {
        Amount = (long)(totalAmount * 100),
        Currency = "EGP",
        Metadata = metaData,
        AutomaticPaymentMethods = new PaymentIntentAutomaticPaymentMethodsOptions
        {
          Enabled = true,
        },
      };

      var seatKey = string.Join("-", dto.Seats.OrderBy(s => s.Row).ThenBy(s => s.SeatNumber)
        .Select(s => $"{s.Row}:{s.SeatNumber}"));

      var requestOptions = new RequestOptions
      {
        IdempotencyKey = $"{userId}-{dto.ShowtimeId}-{seatKey}"
      };

      var service = new PaymentIntentService();
      var paymnetIntent = await service.CreateAsync(options, requestOptions, ct);

      return new PaymentIntentResultDto
      {
        ClientSecret = paymnetIntent.ClientSecret,
        PaymentIntentId = paymnetIntent.Id,
        TotalAmount = totalAmount
      };
    }
  }
}
