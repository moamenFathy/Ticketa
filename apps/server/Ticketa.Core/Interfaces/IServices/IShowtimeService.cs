using Ticketa.Core.DTOs;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IShowtimeService
  {
    Task<object> GetAllAsync(
    DataTableRequestsDto request,
    string? search,
    int orderColumn,
    string orderDir,
    string? segmentedFilter);

    Task<string?> CreateAsync(ShowtimeUpsertDto dto);
    Task<string?> UpdateAsync(ShowtimeUpsertDto dto);
    Task<ShowtimeUpsertDto?> GetForUpsertAsync(int id);

    Task<IEnumerable<HallDto>> GetHallsAsync();
    
    Task<bool> UpdateStatusAsync(int id, Ticketa.Core.Enums.ShowtimeStatus status);
  }
}
