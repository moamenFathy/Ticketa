using Ticketa.Core.DTOs;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IPaymentService
  {
    Task<PaymentIntentResultDto> CreateIntentAsync(CreatePaymentIntentDto dto, string userId, CancellationToken ct = default);
    Task<BookingResultDto> ConfirmAsync(string paymentIntentId, string userId, CancellationToken ct = default);
  }
}
