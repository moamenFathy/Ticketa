using Ticketa.Core.DTOs.Dashboard;

namespace Ticketa.Core.Interfaces.IServices
{
    public interface IDashboardService
    {
        Task<DashboardSummaryDto> GetDashboardSummaryAsync(CancellationToken ct = default);
    }
}
