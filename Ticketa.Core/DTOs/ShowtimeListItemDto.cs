using Ticketa.Core.Enums;

namespace Ticketa.Core.DTOs
{
  public class ShowtimeListItemDto
  {
    public int Id { get; set; }
    public string MovieTitle { get; set; } = string.Empty;
    public string MoviePoster { get; set; } = string.Empty;
    public string HallName { get; set; } = string.Empty;
    public int TotalSeats { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public decimal Price { get; set; }
    public ShowtimeStatus Status { get; set; } = ShowtimeStatus.Scheduled;
    public string? TrailerKey { get; set; }
    public int TmdbId { get; set; }
    public int HallId { get; set; }
  }
}
