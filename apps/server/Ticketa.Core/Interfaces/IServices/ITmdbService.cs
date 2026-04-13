using Ticketa.Core.DTOs;

namespace Ticketa.Core.Interfaces.Services
{
  public interface ITmdbService
  {
    Task<IReadOnlyList<TmdbMovieDto>> GetPopularMoviesAsync();
    Task<string?> GetTrailerKeyAsync(int tmdbId);
  }
}
