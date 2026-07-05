using Ticketa.Core.Entities;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Specification
{
  public class BookingHistoryCountSpecification : BaseSpecification<Booking>
  {
    public BookingHistoryCountSpecification(string userId)
    {
      AddCriteria(b => b.UserId == userId);
    }
  }
}
