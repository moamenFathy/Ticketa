using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.Repositories;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IMovieRepository : IRepository<Movie>
  {
    Task UpdateAsync(Movie movie);
    Task<bool> ExistsByTmdbId(int tmdbId);
  }
}
