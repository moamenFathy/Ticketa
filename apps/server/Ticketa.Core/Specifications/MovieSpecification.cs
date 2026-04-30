using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class MovieSpecification : BaseSpecification<Movie>
  {
    public MovieSpecification(MovieStatus? status = null, string? search = null, int orderColumn = 0, string orderDir = "asc", int? skip = null, int? take = null)
    {
      if (status.HasValue && !string.IsNullOrEmpty(search))
        AddCriteria(m => m.Status == status.Value && m.Title.Contains(search));
      else if (status.HasValue)
        AddCriteria(m => m.Status == status.Value);
      else if (!string.IsNullOrEmpty(search))
        AddCriteria(m => m.Title.Contains(search));

      // Ordering — map column index to actual property
      var isDesc = orderDir.ToLower() == "desc";

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

      if (skip.HasValue && take.HasValue)
        ApplyPaging(skip.Value, take.Value);
    }
  }
}
