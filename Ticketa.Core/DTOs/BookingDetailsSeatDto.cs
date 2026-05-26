namespace Ticketa.Core.DTOs
{
  public class BookingDetailsSeatDto
  {
    public int Row { get; set; }
    public int SeatNumber { get; set; }
    public string Category { get; set; } = string.Empty;
    public decimal Price { get; set; }
  }
}
