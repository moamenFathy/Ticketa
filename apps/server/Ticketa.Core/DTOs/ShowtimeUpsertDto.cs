namespace Ticketa.Core.DTOs
{
  public class ShowtimeUpsertDto
  {
    public int Id { get; set; }
    public int MovieId { get; set; }
    public int HallId { get; set; }
    public DateTime StartTime { get; set; }
    public decimal Price { get; set; }
  }
}
