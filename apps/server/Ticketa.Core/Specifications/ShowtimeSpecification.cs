using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class ShowtimeSpecification : BaseSpecification<Showtime>
  {
    public ShowtimeSpecification()
    {
      AddInclude(s => s.Movie);
      AddInclude(s => s.Hall);
    }

    public ShowtimeSpecification(ShowtimeStatus? status, string? search) : this()
    {
      ApplyFilters(status, search);
    }

    public ShowtimeSpecification(ShowtimeStatus? status, string? search, int orderColumn, string orderDir, int skip, int take) : this(status, search)
    {
      ApplyOrdering(orderColumn, orderDir);
      ApplyPaging(skip, take);
    }

    private void ApplyFilters(ShowtimeStatus? showtimeStatus, string? search)
    {
      if (showtimeStatus.HasValue)
        AddCriteria(s => s.Status == showtimeStatus.Value);

      if (!string.IsNullOrEmpty(search))
        AddCriteria(s => s.Movie.Title.Contains(search) || s.Hall.Name.Contains(search));
    }

    private void ApplyOrdering(int column, string dir)
    {
      bool asc = dir.Equals("asc", StringComparison.OrdinalIgnoreCase);

      switch (column)
      {
        case 3:
          if (asc) AddOrderBy(s => s.StartTime);
          else AddOrderByDesc(s => s.StartTime);
          break;
        case 4:
          if (asc) AddOrderBy(s => s.EndTime);
          else AddOrderByDesc(s => s.EndTime);
          break;
        case 5:
          if (asc) AddOrderBy(s => s.Price);
          else AddOrderByDesc(s => s.Price);
          break;
        default:
          AddOrderByDesc(s => s.StartTime);
          break;
      }
    }
  }
}
