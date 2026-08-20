namespace Ticketa.Core.DTOs.Analytics
{
  public class AnalyticsBreakdownItemDto
  {
    public string Label { get; set; } = string.Empty;
    public int PageViews { get; set; }
    public int Visitors { get; set; }
  }
}