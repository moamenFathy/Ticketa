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

    Task<string?> CreateAsync(ShowtimeCreateDto dto);

    Task<IEnumerable<HallDto>> GetHallsAsync();
    
    Task<bool> UpdateStatusAsync(int id, Ticketa.Core.Enums.ShowtimeStatus status);
  }
}
