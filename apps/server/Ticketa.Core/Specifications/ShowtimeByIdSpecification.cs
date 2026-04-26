using Ticketa.Core.Entities;

namespace Ticketa.Core.Specifications
{
  public class ShowtimeByIdSpecification : BaseSpecification<Showtime>
  {
    public ShowtimeByIdSpecification(int id)
    {
      AddCriteria(s => s.Id == id);
      AddInclude(s => s.Movie);
      AddInclude(s => s.Hall);
    }
  }
}
