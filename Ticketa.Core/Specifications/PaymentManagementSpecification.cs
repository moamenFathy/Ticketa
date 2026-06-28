using Ticketa.Core.Entities;

namespace Ticketa.Core.Specifications
{
  public class PaymentManagementSpecification : BaseSpecification<Payment>
  {
    public PaymentManagementSpecification()
    {
      AddInclude(p => p.User);
      AddInclude(p => p.Showtime);
      AddInclude("Showtime.Movie");
    }

    public PaymentManagementSpecification(int id) : this()
    {
      AddCriteria(p => p.Id == id);
    }
  }
}
