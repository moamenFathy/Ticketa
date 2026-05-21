using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using System;

namespace Ticketa.Core.Specifications
{
  public class ShowtimesForMovieSpecification : BaseSpecification<Showtime>
  {
    public ShowtimesForMovieSpecification(int movieId)
    {
      AddCriteria(s =>
          s.MovieId == movieId &&
          s.Status == ShowtimeStatus.Scheduled);
      AddInclude(s => s.Hall);
      AddOrderBy(s => s.StartTime);
    }
  }
}
