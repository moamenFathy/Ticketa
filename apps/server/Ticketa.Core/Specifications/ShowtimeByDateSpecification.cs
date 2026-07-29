using Ticketa.Core.Entities;

namespace Ticketa.Core.Specifications
{
  public class ShowtimeByDateSpecification : BaseSpecification<Showtime>
  {
    public ShowtimeByDateSpecification(DateTime dayStart, DateTime dayEnd)
    {
      AddCriteria(s => s.StartTime >= dayStart && s.StartTime < dayEnd);
      AddInclude(s => s.Movie);
      AddInclude(s => s.Hall);
    }
  }
}
