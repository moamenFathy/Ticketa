using Microsoft.EntityFrameworkCore;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class MovieRepository : GenericRepository<Movie>, IMovieRepository
  {

    public MovieRepository(ApplicationDbContext context) : base(context) { }

    public async Task<List<int>> ExistingTmdbIdsAsync(IEnumerable<int> tmdbIds)
      => await _context.Movies
          .Where(m => tmdbIds.Contains(m.TmdbId))
          .Select(m => m.TmdbId)
          .ToListAsync();

    public async Task UpdateAsync(Movie movie)
    {
      _context.Movies.Update(movie);
    }
  }
}
