using Ticketa.Core.Entities;

namespace Ticketa.Core.Specifications
{
  public class BookingByRefrenceSpecification : BaseSpecification<Booking>
  {
    public BookingByRefrenceSpecification(string refrence)
    {
      AddCriteria(b => b.BookingRefrence == refrence);
      AddInclude(b => b.BookedSeats);
      AddInclude(b => b.User);
      AddInclude("Showtime.Movie");
      AddInclude("Showtime.Hall");
    }
  }
}
