using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class MovieSpecification : BaseSpecification<Movie>
  {
    public MovieSpecification()
    {
    }

    public MovieSpecification(MovieStatus? status, string? search) : this()
    {
      ApplyFilters(status, search);
    }

    public MovieSpecification(MovieStatus? status, string? search, int orderColumn, string orderDir, int skip, int take) : this(status, search)
    {
      ApplyOrdering(orderColumn, orderDir);
      ApplyPaging(skip, take);
    }

    private void ApplyFilters(MovieStatus? status, string? search)
    {
      if (status.HasValue && !string.IsNullOrEmpty(search))
        AddCriteria(m => m.Status == status.Value && m.Title.Contains(search));
      else if (status.HasValue)
        AddCriteria(m => m.Status == status.Value);
      else if (!string.IsNullOrEmpty(search))
        AddCriteria(m => m.Title.Contains(search));
    }

    private void ApplyOrdering(int orderColumn, string orderDir)
    {
      var isDesc = orderDir.Equals("desc", StringComparison.OrdinalIgnoreCase);

      switch (orderColumn)
      {
        case 3: // VoteAverage column
          if (isDesc) AddOrderByDesc(m => m.VoteAverage);
          else AddOrderBy(m => m.VoteAverage);
          break;
        case 4: // ReleaseDate column
          if (isDesc) AddOrderByDesc(m => m.ReleaseDate);
          else AddOrderBy(m => m.ReleaseDate);
          break;
        case 5: // ImportedAt column
          if (isDesc) AddOrderByDesc(m => m.ImportedAt);
          else AddOrderBy(m => m.ImportedAt);
          break;
        case 6: // Runtime column
          if (isDesc) AddOrderByDesc(m => m.RuntimeMinutes);
          else AddOrderBy(m => m.RuntimeMinutes);
          break;
        default:
          AddOrderByDesc(m => m.ImportedAt);
          break;
      }
    }
  }
}
