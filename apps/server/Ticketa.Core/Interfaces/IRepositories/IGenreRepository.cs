using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IGenreRepository : IGenericRepository<Genre>
  {
    Task<List<Genre>> GetByTmdbIdsAsync(IEnumerable<int> ids);
    Task AddRangeAsync(IEnumerable<Genre> genres);
  }
}
