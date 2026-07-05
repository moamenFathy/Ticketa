using Ticketa.Core.Enums;

namespace Ticketa.Core.DTOs.Profile
{
  public class BookingHistoryItemDto
  {
    public string BookingReference { get; set; } = "";
    public string MovieTitle { get; set; } = "";
    public string? MoviePosterPath { get; set; }
    public DateTime ShowtimeStartsAt { get; set; }
    public int SeatCount { get; set; }
    public decimal TotalAmount { get; set; }
    public BookingStatus Status { get; set; }
  }
}
