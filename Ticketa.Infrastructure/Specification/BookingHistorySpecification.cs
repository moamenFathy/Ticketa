using Ticketa.Core.Entities;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Specification
{
  public class BookingHistorySpecification : BaseSpecification<Booking>
  {
    public BookingHistorySpecification(string userId, int page, int pageSize)
    {
      AddCriteria(b => b.UserId == userId);
      AddInclude(b => b.Showtime.Movie);
      AddInclude(b => b.Showtime.Hall);
      AddInclude(b => b.BookedSeats);
      AddOrderByDesc(b => b.BookedAt);
      ApplyPaging((page - 1) * pageSize, pageSize);
    }
  }
}
