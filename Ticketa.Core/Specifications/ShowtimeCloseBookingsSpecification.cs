using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class ShowtimeCloseBookingsSpecification : BaseSpecification<Showtime>
  {
    public ShowtimeCloseBookingsSpecification()
    {
      AddCriteria(s =>
        (s.Status == ShowtimeStatus.Scheduled || s.Status == ShowtimeStatus.SoldOut)
        && !s.IsArchived
        && s.StartTime <= DateTime.UtcNow.AddMinutes(10));
    }
  }
}
