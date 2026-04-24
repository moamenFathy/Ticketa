using Ticketa.Core.Enums;

namespace Ticketa.Core.Entities
{
  public class Showtime
  {
    public int Id { get; set; }
    public int MovieId { get; set; }
    public int HallId { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public decimal Price { get; set; }
    public ShowtimeStatus Status { get; set; } = ShowtimeStatus.Scheduled;

    public Movie Movie { get; set; } = null!;
    public Hall Hall { get; set; } = null!;
  }
}
