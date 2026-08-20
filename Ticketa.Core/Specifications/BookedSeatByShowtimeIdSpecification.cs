using Ticketa.Core.Entities;

namespace Ticketa.Core.Specifications
{
  public class BookedSeatByShowtimeIdSpecification : BaseSpecification<BookedSeat>
  {
    public BookedSeatByShowtimeIdSpecification(int showtimeId)
    {
      AddCriteria(s => s.ShowtimeId == showtimeId);
    }
  }
}
