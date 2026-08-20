using Ticketa.Core.DTOs.Analytics;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IVercelAnalyticsService
  {
    Task<SiteAnalyticsSummaryDto> GetSummaryAsync(DateOnly since, DateOnly until, CancellationToken ct = default);
  }
}