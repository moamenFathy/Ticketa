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

    Task<string?> CreateAsync(ShowtimeUpsertDto dto);
    Task<string?> UpdateAsync(ShowtimeUpsertDto dto);
    Task<ShowtimeUpsertDto?> GetForUpsertAsync(int id);

    Task<IEnumerable<HallDto>> GetHallsAsync();

    Task<bool> UpdateStatusAsync(int id, ShowtimeStatus status);

    public Task<Showtime?> GetByIdAsync(int id);
    Task<IEnumerable<MovieShowtimeDto>> GetScheduledGroupedAsync(CancellationToken ct = default);

    Task<ShowtimeSeatDto?> GetSeatMapAsync(int showtimeId, CancellationToken ct = default);

    public Task<bool> DeleteAsync(int id);
  }
}
