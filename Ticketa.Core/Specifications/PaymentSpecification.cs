using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class PaymentSpecification : BaseSpecification<Payment>
  {
    public PaymentSpecification()
    {
      AddInclude(p => p.PaymentSeats);
    }

    public PaymentSpecification(string userId, int showtimeId, string seatHash)
      : this()
    {
      AddCriteria(p => p.UserId == userId
                    && p.ShowtimeId == showtimeId
                    && p.SeatHash == seatHash
                    && p.Status == PaymentStatus.Pending);
    }

    public PaymentSpecification(int? showtimeId, string? userId,
        PaymentStatus? status, bool includeUser, bool includeShowtime,
        int skip, int take) : this()
    {
      if (showtimeId.HasValue)
        AddCriteria(p => p.ShowtimeId == showtimeId.Value);
      if (!string.IsNullOrEmpty(userId))
        AddCriteria(p => p.UserId == userId);
      if (status.HasValue)
        AddCriteria(p => p.Status == status.Value);

      if (includeUser)
        AddInclude(p => p.User);
      if (includeShowtime)
      {
        AddInclude(p => p.Showtime);
        AddInclude("Showtime.Movie");
        AddInclude("Showtime.Hall");
      }

      ApplyPaging(skip, take);
    }
  }
}
