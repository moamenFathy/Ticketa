using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IShowtimeRepository : IGenericRepository<Showtime>
  {
    Task<bool> HasConflictAsync(int hallId, DateTime startTime, DateTime endTime, int? excludeShowtimeId = null);
    Task UpdateAsync(Showtime showtime);
  }
}
