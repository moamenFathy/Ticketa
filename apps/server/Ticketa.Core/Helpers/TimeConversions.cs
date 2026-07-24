using Microsoft.Extensions.Configuration;

namespace Ticketa.Core.Helpers
{
  public class TimeConversions
  {
    private readonly IConfiguration _configuration;
    private readonly TimeZoneInfo _appTimeZone;
    public TimeConversions(IConfiguration configuration)
    {
      _configuration = configuration;
      var tzId = configuration["AppTimeZone"] ?? "Africa/Cairo";
      TimeZoneInfo tz;
      try { tz = TimeZoneInfo.FindSystemTimeZoneById(tzId); }
      catch { tz = TimeZoneInfo.Utc; }
      _appTimeZone = tz;
    }

    public DateTime ConvertToUtc(DateTime local) =>
    TimeZoneInfo.ConvertTimeToUtc(DateTime.SpecifyKind(local, DateTimeKind.Unspecified), _appTimeZone);

    public DateTime ConvertFromUtc(DateTime utc) =>
        DateTime.SpecifyKind(TimeZoneInfo.ConvertTimeFromUtc(DateTime.SpecifyKind(utc, DateTimeKind.Utc), _appTimeZone), DateTimeKind.Unspecified);

    public DateTime EnsureUtcKind(DateTime dt) =>
        DateTime.SpecifyKind(dt, DateTimeKind.Utc);

  }
}
