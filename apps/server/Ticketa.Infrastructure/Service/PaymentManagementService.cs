using Stripe;
using Ticketa.Core.DTOs.Payments;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Service
{
  public class PaymentManagementService(IUnitOfWork uow, IBookingService bookingService) : IPaymentManagementService
  {
    private readonly IUnitOfWork _uow = uow;
    private readonly IBookingService _bookingService = bookingService;

    public async Task<List<PaymentListItemDto>> GetAllAsync()
    {
      var spec = new PaymentManagementSpecification();
      var payments = await _uow.Payments.GetAllWithSpecAsync(spec);

      return payments.Select(p => new PaymentListItemDto
      {
        Id = p.Id,
        StripePaymentIntentId = p.StripePaymentIntentId,
        UserName = $"{p.User.FirstName} {p.User.LastName}",
        UserEmail = p.User.Email ?? "",
        MovieTitle = p.Showtime.Movie.Title,
        TotalAmount = p.TotalAmount,
        Status = p.Status.ToString(),
        CreatedAt = p.CreatedAt,
        RefundedAt = p.RefundedAt,
        BookingReference = "",
        BookingStatus = ""
      }).OrderByDescending(p => p.CreatedAt).ToList();
    }

    public async Task<(bool Success, string Message)> RefundAsync(int paymentId)
    {
      var spec = new PaymentManagementSpecification(paymentId);
      var payment = await _uow.Payments.GetEntityWithSpecAsync(spec);

      if (payment is null)
        return (false, "Payment not found.");

      if (payment.Status == PaymentStatus.Refunded)
        return (false, "Payment has already been refunded.");

      try
      {
        var refundService = new RefundService();
        await refundService.CreateAsync(
            new RefundCreateOptions { PaymentIntent = payment.StripePaymentIntentId }
          );

        payment.Status = PaymentStatus.Refunded;
        payment.RefundedAt = DateTime.UtcNow;
        await _uow.SaveAsync();

        var (success, message) = await _bookingService.CancelBookingsForPaymentAsync(payment.ShowtimeId, payment.PaymentSeats);
        if (!success)
          return (false, message);

        return (true, "Payment refunded successfully.");
      }
      catch (StripeException ex)
      {
        return (false, $"Stripe error: {ex.Message}");
      }
    }
  }
}
