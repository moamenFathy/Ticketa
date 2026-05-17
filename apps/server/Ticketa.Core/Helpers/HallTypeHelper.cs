using Ticketa.Core.Enums;

namespace Ticketa.Core.Helpers
{
  public static class HallTypeHelper
  {
    public static IReadOnlyList<SeatCategory> GetAllowedCategories(HallType type) => type switch
    {
      HallType.Standard => [SeatCategory.Regular, SeatCategory.VIP],
      HallType.IMAX     => [SeatCategory.Regular, SeatCategory.Premium],
      HallType.Gold     => [SeatCategory.Regular],
      _                 => []
    };

    public static HallTemplate GetTemplate(HallType type) => type switch
    {
      HallType.Standard => new HallTemplate
      {
        Type        = HallType.Standard,
        Rows        = 12,
        SeatsPerRow = 16,
        RowCategoryMap = BuildMap(regularRows: 9, premiumRows: 3,
            regular: SeatCategory.Regular, premium: SeatCategory.VIP)
      },
      HallType.IMAX => new HallTemplate
      {
        Type        = HallType.IMAX,
        Rows        = 14,
        SeatsPerRow = 16,
        RowCategoryMap = BuildMap(regularRows: 10, premiumRows: 4,
            regular: SeatCategory.Regular, premium: SeatCategory.Premium)
      },
      HallType.Gold => new HallTemplate
      {
        Type        = HallType.Gold,
        Rows        = 6,
        SeatsPerRow = 8,
        RowCategoryMap = BuildMap(regularRows: 6, premiumRows: 0,
            regular: SeatCategory.Regular, premium: SeatCategory.Regular)  // all Regular
      },
      _ => throw new ArgumentOutOfRangeException(nameof(type), type, null)
    };

    private static Dictionary<int, SeatCategory> BuildMap(
        int regularRows, int premiumRows,
        SeatCategory regular, SeatCategory premium)
    {
      var map = new Dictionary<int, SeatCategory>();

      for (int r = 1; r <= regularRows; r++)
        map[r] = regular;

      for (int r = regularRows + 1; r <= regularRows + premiumRows; r++)
        map[r] = premium;

      return map;
    }
  }
}
