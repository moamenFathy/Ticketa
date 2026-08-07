using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Specification
{
  public class BookingHistoryCountSpecification : BaseSpecification<Booking>
  {
    public BookingHistoryCountSpecification(string userId, BookingHistoryFilter filter = BookingHistoryFilter.All)
    {
      var now = DateTime.UtcNow;
      AddCriteria(b => b.UserId == userId
        && (filter != BookingHistoryFilter.Upcoming || b.Showtime.StartTime >= now)
        && (filter != BookingHistoryFilter.Past || b.Showtime.StartTime < now));
    }
  }
}
