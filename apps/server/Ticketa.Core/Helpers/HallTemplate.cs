using Ticketa.Core.Enums;

namespace Ticketa.Core.Helpers
{
  public class HallTemplate
  {
    public HallType Type { get; set; }
    public int Rows { get; set; }
    public int SeatsPerRow { get; set; }

    public Dictionary<int, SeatCategory> RowCategoryMap { get; set; } = new();
  }
}
