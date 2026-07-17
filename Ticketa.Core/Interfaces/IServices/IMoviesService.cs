using Ticketa.Core.DTOs;
using Ticketa.Core.DTOs.Common;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IMoviesService
  {
    Task<MovieImportResultDto> ImportMoviesAsync(List<int> ids, CancellationToken ct);

    Task<IEnumerable<MovieSearchResultDto>> SearchMoviesAsync(string query, CancellationToken ct);

    Task<bool> UpdateStatusAsync(int id, MovieStatus status);

    Task<Movie?> GetByIdAsync(int id);

    Task<string?> DeleteAsync(int id);

    Task<object> GetAllAsync(
        DataTableRequestsDto request,
        string? search,
        int orderColumn,
        string orderDir,
        string? segmentedFilter);

    Task<object> GetAllArchivedAsync(
        DataTableRequestsDto request,
        string? search,
        int orderColumn,
        string orderDir,
        string? segmentedFilter);

    Task<IEnumerable<MovieDropdownDto>> GetAllActiveAsync();

    Task<PagedResultDto<ActiveMovieWithDetailsDto>> GetAllActiveWithDetailsAsync(int page, int pageSize, CancellationToken ct = default);
    Task<IEnumerable<ActiveMovieWithDetailsDto>> GetNowShowingMoviesAsync(CancellationToken ct = default);
    Task<IEnumerable<ActiveMovieWithDetailsDto>> GetComingSoonMoviesAsync(CancellationToken ct = default);
    Task<ActiveMovieWithDetailsDto?> GetActiveMovieWithDetailsByIdAsync(int id, CancellationToken ct = default);
    Task<List<TopBookedMovieDto>> GetTopBookedMoviesAsync(int count = 6, CancellationToken ct = default);
  }
}
