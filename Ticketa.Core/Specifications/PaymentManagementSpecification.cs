using Ticketa.Core.Entities;

namespace Ticketa.Core.Specifications
{
  public class PaymentManagementSpecification : BaseSpecification<Payment>
  {
    public PaymentManagementSpecification()
    {
      AddInclude(p => p.User);
      AddInclude(p => p.Showtime);
      AddInclude(p => p.PaymentSeats);
      AddInclude("Showtime.Movie");
    }

    public PaymentManagementSpecification(int id) : this()
    {
      AddCriteria(p => p.Id == id);
    }

    public PaymentManagementSpecification(string? search) : this()
    {
      ApplySearch(search);
    }

    public PaymentManagementSpecification(string? search, int orderColumn, string orderDir, int skip, int take) : this(search)
    {
      ApplyOrdering(orderColumn, orderDir);
      ApplyPaging(skip, take);
    }

    private void ApplySearch(string? search)
    {
      if (string.IsNullOrWhiteSpace(search))
        return;

      AddCriteria(p =>
          (p.User.FirstName + " " + p.User.LastName).Contains(search) ||
          p.User.Email!.Contains(search) ||
          p.Showtime.Movie.Title.Contains(search) ||
          (p.BookingReference != null && p.BookingReference.Contains(search)));
    }

    private void ApplyOrdering(int orderColumn, string orderDir)
    {
      var isDesc = orderDir.Equals("desc", StringComparison.OrdinalIgnoreCase);

      switch (orderColumn)
      {
        case 0: // userName
          if (isDesc) AddOrderByDesc(p => p.User.FirstName);
          else AddOrderBy(p => p.User.FirstName);
          break;
        case 1: // userEmail
          if (isDesc) AddOrderByDesc(p => p.User.Email!);
          else AddOrderBy(p => p.User.Email!);
          break;
        case 2: // movieTitle
          if (isDesc) AddOrderByDesc(p => p.Showtime.Movie.Title);
          else AddOrderBy(p => p.Showtime.Movie.Title);
          break;
        case 3: // totalAmount
          if (isDesc) AddOrderByDesc(p => p.TotalAmount);
          else AddOrderBy(p => p.TotalAmount);
          break;
        case 4: // status
          if (isDesc) AddOrderByDesc(p => p.Status);
          else AddOrderBy(p => p.Status);
          break;
        case 5: // createdAt
          if (isDesc) AddOrderByDesc(p => p.CreatedAt);
          else AddOrderBy(p => p.CreatedAt);
          break;
        default:
          AddOrderByDesc(p => p.CreatedAt);
          break;
      }
    }
  }
}
