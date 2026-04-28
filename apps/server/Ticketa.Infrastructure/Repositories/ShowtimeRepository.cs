using Microsoft.EntityFrameworkCore;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Core.Specifications;
using Ticketa.Infrastructure.Data;
using Ticketa.Infrastructure.Specification;

namespace Ticketa.Infrastructure.Repositories
{
  public class ShowtimeRepository : GenericRepository<Showtime>, IShowtimeRepository
  {

    public ShowtimeRepository(ApplicationDbContext context) : base(context) { }

    public Task<bool> HasConflictAsync(int hallId, DateTime startTime, DateTime endTime, int? excludeId = null)
      => _context.Showtimes
         .Where(s => s.HallId == hallId
                      && s.Status != ShowtimeStatus.Completed
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

    public async Task<IEnumerable<ShowtimeListItemDto>> GetShowtimeListAsync(ShowtimeSpecification spec)
    {
      return await SpecificationEvaluator<Showtime>.GetQuery(_context.Showtimes, spec)
      .Select(s => new ShowtimeListItemDto
      {
        Id = s.Id,
        MovieTitle = s.Movie.Title,
        MoviePoster = s.Movie.PosterPath,
        HallName = s.Hall.Name,
        TotalSeats = s.Hall.TotalSeats,
        StartTime = s.StartTime,
        EndTime = s.EndTime,
        Price = s.Price,
        Status = s.Status,
        TrailerKey = s.Movie.TrailerKey,
        TmdbId = s.Movie.TmdbId
      }).ToListAsync();
    }
  }
}
