using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class UpcomingShowtimesForMoviesSpecification : BaseSpecification<Showtime>
  {
    public UpcomingShowtimesForMoviesSpecification(IEnumerable<int> movieIds)
    {
      var ids = movieIds.ToList();
      AddCriteria(s =>
          ids.Contains(s.MovieId) &&
          s.Status == ShowtimeStatus.Scheduled);
      AddInclude(s => s.Hall);
      AddOrderBy(s => s.StartTime);
    }
  }
}
