using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class ShowtimeSpecification : BaseSpecification<Showtime>
  {
    public ShowtimeSpecification(bool? archivedOnly = false)
    {
      if (archivedOnly.HasValue)
      {
        if (archivedOnly.Value)
          AddCriteria(s => s.IsArchived);
        else
          AddCriteria(s => !s.IsArchived);
      }
      AddInclude(s => s.Movie);
      AddInclude(s => s.Hall);
      AddInclude("Movie.Genres");
    }

    public ShowtimeSpecification(ShowtimeStatus? status, string? search, bool? archivedOnly = false) : this(archivedOnly)
    {
      ApplyFilters(status, search);
    }

    private void ApplyFilters(ShowtimeStatus? showtimeStatus, string? search)
    {
      if (showtimeStatus.HasValue)
        AddCriteria(s => s.Status == showtimeStatus.Value);

      if (!string.IsNullOrEmpty(search))
        AddCriteria(s => s.Movie.Title.Contains(search) || s.Hall.Name.Contains(search));
    }
  }
}
