using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class BookingByUserAndShowtimeSpecification : BaseSpecification<Booking>
  {
    public BookingByUserAndShowtimeSpecification(string userId, int showtimeId)
    {
      AddCriteria(b => b.UserId == userId
                    && b.ShowtimeId == showtimeId
                    && b.Status == BookingStatus.Confirmed);
    }
  }
}
