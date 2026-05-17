using Ticketa.Core.Enums;

namespace Ticketa.Core.Entities
{
  public class BookedSeat
  {
    public int Id { get; set; }
    public int BookingId { get; set; }
    public int ShowtimeId { get; set; }
    public int Row { get; set; }
    public int SeatNumber { get; set; }
    public SeatCategory Category { get; set; }
    public decimal Price { get; set; }

    public Booking Booking { get; set; } = null!;
    public Showtime Showtime { get; set; } = null!;
  }
}
