using Ticketa.Core.DTOs;
using Ticketa.Core.DTOs.Payments;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IPaymentManagementService
  {
    Task<List<PaymentListItemDto>> GetAllAsync();
    Task<object> GetAllAsync(DataTableRequestsDto request, string? search, int orderColumn, string orderDir);
    Task<(bool Success, string Message)> RefundAsync(int paymentId);
  }
}
