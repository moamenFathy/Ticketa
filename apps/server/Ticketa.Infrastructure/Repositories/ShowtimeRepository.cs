using Microsoft.EntityFrameworkCore;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class ShowtimeRepository : GenericRepository<Showtime>, IShowtimeRepository
  {

    public ShowtimeRepository(ApplicationDbContext context) : base(context) { }

    public Task<bool> HasConflictAsync(int hallId, DateTime startTime, DateTime endTime, int? excludeId = null)
      => _context.Showtimes
         .Where(s => s.HallId == hallId
                      && s.Status != ShowtimeStatus.Cancelled
                      && (excludeId == null || s.Id != excludeId)
                      && s.StartTime < endTime
                      && s.EndTime > startTime
         )
         .AnyAsync();

    public Task UpdateAsync(Showtime showtime)
    {
      _context.Showtimes.Update(showtime);
      return Task.CompletedTask;
    }
  }
}
