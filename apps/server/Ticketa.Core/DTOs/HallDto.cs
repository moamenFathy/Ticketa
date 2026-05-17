using Ticketa.Core.Enums;

namespace Ticketa.Core.DTOs
{
  public class HallDto
  {
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public HallType Type { get; set; }
    public int TotalRows { get; set; }
    public int SeatsPerRow { get; set; }
    public int TotalSeats => TotalRows * SeatsPerRow;
  }
}
