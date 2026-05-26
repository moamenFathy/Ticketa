namespace Ticketa.Core.DTOs
{
  public class BookingResultDto
  {
    public bool Succeeded { get; set; }
    public bool IsNotFound { get; set; }
    public string? BookingReference { get; set; }
    public decimal? TotalAmount { get; set; }
    public List<SeatDto> ConflictingSeats { get; set; } = [];

    public static BookingResultDto Success(string refrence, decimal total) => new()
    {
      Succeeded = true,
      BookingReference = refrence,
      TotalAmount = total
    };

    public static BookingResultDto NotFound() => new() { IsNotFound = true };

    public static BookingResultDto Conflict(IEnumerable<SeatDto> seats) => new()
    {
      Succeeded = false,
      ConflictingSeats = seats.ToList()
    };
  }
}
