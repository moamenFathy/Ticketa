using Ticketa.Core.Enums;

namespace Ticketa.Core.DTOs
{
  public class ShowtimeListItemDto
  {
    public int Id { get; set; }
    public string HallName { get; set; } = string.Empty;
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public decimal Price { get; set; }
    public ShowtimeStatus Status { get; set; } = ShowtimeStatus.Scheduled;
    public int HallId { get; set; }
    public int TotalSeats { get; set; }
  }
}
