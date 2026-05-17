using Ticketa.Core.Enums;

namespace Ticketa.Core.Entities
{
  public class Booking
  {
    public int Id { get; set; }
    public string UserId { get; set; } = string.Empty;
    public int ShowtimeId { get; set; }
    public DateTime BookedAt { get; set; }
    public decimal TotalAmount { get; set; }
    public BookingStatus Status { get; set; }
    public string BookingRefrence { get; set; } = string.Empty;

    public AppUser User { get; set; } = null!;
    public Showtime Showtime { get; set; } = null!;
    public ICollection<BookedSeat> BookedSeats { get; set; } = new List<BookedSeat>();
  }
}
