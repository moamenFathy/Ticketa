using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IMovieRepository : IGenericRepository<Movie>
  {
    Task UpdateAsync(Movie movie);
    Task<bool> ExistsByTmdbId(int tmdbId);
  }
}
