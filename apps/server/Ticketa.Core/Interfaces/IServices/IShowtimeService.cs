using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IShowtimeService
  {
    public Task<IEnumerable<MovieShowtimeDto>> GetAllAsync(
            string? search,
            string? segmentedFilter);

    Task<object> GetAllAsync(DataTableRequestsDto request, string? search, string? segmentedFilter);

    Task<string?> CreateAsync(ShowtimeUpsertDto dto);
    Task<string?> UpdateAsync(ShowtimeUpsertDto dto);
    Task<ShowtimeUpsertDto?> GetForUpsertAsync(int id);

    Task<IEnumerable<HallDto>> GetHallsAsync();


    public Task<Showtime?> GetByIdAsync(int id);
    Task<IEnumerable<MovieShowtimeDto>> GetScheduledGroupedAsync(CancellationToken ct = default);

    Task<ShowtimeSeatDto?> GetSeatMapAsync(int showtimeId, CancellationToken ct = default);

    public Task<string?> DeleteAsync(int id);

    Task<IEnumerable<HallTimelineDto>> GetByDateAsync(DateOnly date, CancellationToken ct = default);

    Task<ShowtimeBatchResultDto> SaveBatchAsync(ShowtimeBatchSaveDto dto, CancellationToken ct = default);
  }
}
