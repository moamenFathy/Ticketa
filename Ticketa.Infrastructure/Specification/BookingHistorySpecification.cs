using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Specification
{
  public class BookingHistorySpecification : BaseSpecification<Booking>
  {
    public BookingHistorySpecification(string userId, int page, int pageSize, BookingHistoryFilter filter = BookingHistoryFilter.All)
    {
      var now = DateTime.UtcNow;

      AddCriteria(b => b.UserId == userId
        && (filter != BookingHistoryFilter.Upcoming || b.Showtime.StartTime >= now)
        && (filter != BookingHistoryFilter.Past || b.Showtime.StartTime < now));
      AddInclude(b => b.Showtime.Movie);
      AddInclude(b => b.Showtime.Hall);
      AddInclude(b => b.BookedSeats);

      if (filter == BookingHistoryFilter.Upcoming)
      {
        AddOrderBy(b => b.Showtime.StartTime);
      }
      else if (filter == BookingHistoryFilter.Past)
      {
        AddOrderByDesc(b => b.Showtime.StartTime);
      }
      else
      {
        AddOrderByDesc(b => b.BookedAt);
      }

      ApplyPaging((page - 1) * pageSize, pageSize);
    }
  }
}
