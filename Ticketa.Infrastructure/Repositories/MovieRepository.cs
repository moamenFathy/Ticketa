using Microsoft.EntityFrameworkCore;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class MovieRepository : Repository<Movie>, IMovieRepository
  {

    public MovieRepository(ApplicationDbContext context) : base(context) { }

    public async Task<bool> ExistsByTmdbId(int tmdbId) => await _context.Movies.AnyAsync(m => m.TmdbId == tmdbId);

    public async Task UpdateAsync(Movie movie)
    {
      _context.Movies.Update(movie);
    }
  }
}
