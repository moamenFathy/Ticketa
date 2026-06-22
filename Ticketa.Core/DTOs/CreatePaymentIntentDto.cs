namespace Ticketa.Core.DTOs
{
  public class CreatePaymentIntentDto
  {
    public int ShowtimeId { get; set; }
    public List<SeatDto> Seats { get; set; } = [];
  }
}
