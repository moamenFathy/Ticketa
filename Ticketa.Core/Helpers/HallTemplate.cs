using Ticketa.Core.Enums;

namespace Ticketa.Core.Helpers
{
  public class HallTemplate
  {
    public HallType Type { get; set; }
    public int Rows { get; set; }
    public int SeatsPerRow { get; set; }
    public Dictionary<int, SeatCategory> RowCategoryMap { get; set; } = new();
    public Dictionary<SeatCategory, decimal> CategorySurchargeMape { get; set; } = new();

    // Stadium bowl shape: invisible spacer seats that can't be booked
    private static int GetSkip(int rowIndex, int totalRows) => (rowIndex, totalRows) switch
    {
      (0, _) => 3,
      (_, var t) when rowIndex == t - 1 => 2,
      _ => 0
    };

    public int InvisibleSeatCount
    {
      get
      {
        int count = 0;
        for (int r = 0; r < Rows; r++)
          count += GetSkip(r, Rows) * 2;
        return count;
      }
    }

    public int VisibleSeatCount => (Rows * SeatsPerRow) - InvisibleSeatCount;
  }
}
