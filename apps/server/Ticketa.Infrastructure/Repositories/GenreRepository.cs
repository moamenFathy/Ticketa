using Microsoft.EntityFrameworkCore;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class GenreRepository : GenericRepository<Genre>, IGenreRepository
  {

    public GenreRepository(ApplicationDbContext context) : base(context) { }

    public Task AddRangeAsync(IEnumerable<Genre> genres) => _context.AddRangeAsync(genres);

    public Task<List<Genre>> GetByTmdbIdsAsync(IEnumerable<int> ids)
      => _context.Genres
                 .Where(g => ids.Contains(g.TmdbId))
                 .ToListAsync();
  }
}
