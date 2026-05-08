using Ticketa.Core.DTOs;

namespace Ticketa.Core.Interfaces.Services
{
  public interface ITmdbService
  {
    Task<IReadOnlyList<TmdbMovieDto>> GetPopularMoviesAsync(CancellationToken ct = default);
    Task<TmdbMovieDto?> GetMovieByIdAsync(int tmdbId, CancellationToken ct = default);
    Task<string?> GetTrailerKeyAsync(int tmdbId, CancellationToken ct = default);
    Task<IReadOnlyList<TmdbMovieDto>> SearchMoviesAsync(string query, CancellationToken ct = default);
    Task<TmdbMovieDetailDto> GetMovieDetailAsync(int tmdbId, CancellationToken ct = default);
    Task<TmdbCreditsDto?> GetCreditsAsync(int tmdbId, CancellationToken ct = default);
  }
}
