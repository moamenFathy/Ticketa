namespace Ticketa.Core.DTOs.Analytics
{
  public class SiteAnalyticsSummaryDto
  {
    public int PageViews { get; set; }
    public int Visitors { get; set; }
    public List<AnalyticsBreakdownItemDto> ByCountry { get; set; } = [];
    public List<AnalyticsBreakdownItemDto> ByDevice { get; set; } = [];
    public List<AnalyticsBreakdownItemDto> ByOs { get; set; } = [];
    public List<AnalyticsBreakdownItemDto> ByBrowser { get; set; } = [];
  }
}