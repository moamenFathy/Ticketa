using Ticketa.Core.Entities;

namespace Ticketa.Core.Specifications
{
  public class HallSpecification : BaseSpecification<Hall>
  {
    public HallSpecification()
    {
      AddInclude(h => h.Showtimes);
    }
  }
}
