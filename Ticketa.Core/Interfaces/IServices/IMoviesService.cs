using Ticketa.Core.DTOs;
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

    Task<bool> DeleteAsync(int id);

    Task<object> GetAllAsync(
        DataTableRequestsDto request,
        string? search,
        int orderColumn,
        string orderDir,
        string? segmentedFilter);
  }
}
