namespace Ticketa.Core.DTOs
{
  public class BookingCreateDto
  {
    public int ShowtimeId { get; set; }
    public List<SeatDto> Seats { get; set; } = [];
  }
}
