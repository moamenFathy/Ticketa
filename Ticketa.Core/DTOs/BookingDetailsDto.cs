using Ticketa.Core.Enums;

namespace Ticketa.Core.DTOs
{
  public class BookingDetailsDto
  {
    public string UserId { get; set; } = string.Empty;
    public string UserEmail { get; set; } = string.Empty;
    public string BookingRefrence { get; set; } = string.Empty;
    public BookingStatus Status { get; set; }
    public DateTime BookedAt { get; set; }
    public decimal TotalAmount { get; set; }

    public string MovieTitle { get; set; } = string.Empty;
    public string? MoviePosterPath { get; set; }

    public DateTime StartsAt { get; set; }

    public string HallName { get; set; } = string.Empty;
    public string HallType { get; set; } = string.Empty;

    public List<BookingDetailsSeatDto> Seats { get; set; } = [];
  }
}
