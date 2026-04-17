using Ticketa.Core.DTOs;

namespace Ticketa.Core.Interfaces.Services
{
  public interface ITmdbService
  {
    Task<IReadOnlyList<TmdbMovieDto>> GetPopularMoviesAsync();
    Task<TmdbMovieDto?> GetMovieByIdAsync(int tmdbId);
    Task<string?> GetTrailerKeyAsync(int tmdbId);
    Task<IReadOnlyList<TmdbMovieDto>> SearchMoviesAsync(string query);
    Task<TmdbMovieDetailDto> GetMovieDetailAsync(int tmdbId);
  }
}
