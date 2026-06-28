using Ticketa.Core.DTOs.Payments;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IPaymentManagementService
  {
    Task<List<PaymentListItemDto>> GetAllAsync();
    Task<(bool Success, string Message)> RefundAsync(int paymentId);
  }
}
