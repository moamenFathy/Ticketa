using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Specifications;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IShowtimeRepository : IGenericRepository<Showtime>
  {
    Task<bool> HasConflictAsync(int hallId, DateTime startTime, DateTime endTime, int? excludeShowtimeId = null);
    Task UpdateAsync(Showtime showtime);
    Task<IEnumerable<ShowtimeListItemDto>> GetShowtimeListAsync(ShowtimeSpecification spec);
  }
}
