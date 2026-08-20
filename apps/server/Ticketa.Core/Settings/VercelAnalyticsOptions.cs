namespace Ticketa.Core.Settings
{
  public class VercelAnalyticsOptions
  {
    public string Token { get; set; } = string.Empty;
    public string ProjectId { get; set; } = string.Empty;
    public string? TeamId { get; set; }
  }
}