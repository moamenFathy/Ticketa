using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IMovieRepository : IGenericRepository<Movie>
  {
    Task UpdateAsync(Movie movie);
    Task<List<int>> ExistingTmdbIdsAsync(IEnumerable<int> tmdbIds);
  }
}
