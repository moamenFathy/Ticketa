using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Specifications
{
  public class ShowtimeCompletionSpecification : BaseSpecification<Showtime>
  {
    public ShowtimeCompletionSpecification()
    {
      AddCriteria(s => s.Status == ShowtimeStatus.Scheduled && !s.IsArchived && s.EndTime < DateTime.UtcNow);
    }
  }
}
