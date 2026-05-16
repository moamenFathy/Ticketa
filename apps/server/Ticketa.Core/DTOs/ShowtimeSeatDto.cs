namespace Ticketa.Core.DTOs
{
  public class ShowtimeSeatDto
  {
    public int ShowtimeId { get; set; }
    public string MovieTitle { get; set; } = string.Empty;
    public string? MoviePosterPath { get; set; }
    public string HallName { get; set; } = string.Empty;
    public string HallType { get; set; } = string.Empty;
    public DateTime StartsAt { get; set; }
    public int Rows { get; set; }
    public int SeatsPerRow { get; set; }
    public Dictionary<int, string> RowCategoryMap { get; set; } = new();
    public List<SeatDto> BookedSeats { get; set; } = [];
  }
}
