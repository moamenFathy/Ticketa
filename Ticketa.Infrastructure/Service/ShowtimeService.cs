using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Service
{
  public class ShowtimeService : IShowtimeService
  {
    private const int BufferMinutes = 15;

    private readonly IUnitOfWork _uow;

    public ShowtimeService(IUnitOfWork uow) => _uow = uow;

    // ── DataTables ───────────────────────────────────────────────

    public async Task<object> GetAllAsync(
        DataTableRequestsDto request,
        string? search,
        int orderColumn,
        string orderDir,
        string? segmentedFilter)
    {
      ShowtimeStatus? status = segmentedFilter?.ToLower() switch
      {
        "scheduled" => ShowtimeStatus.Scheduled,
        "soldout" => ShowtimeStatus.SoldOut,
        "cancelled" => ShowtimeStatus.Cancelled,
        "completed" => ShowtimeStatus.Completed,
        _ => null
      };

      var query = string.IsNullOrWhiteSpace(search) ? null : search;

      var total = await _uow.Showtimes.CountAsync(new ShowtimeSpecification());
      var filtered = await _uow.Showtimes.CountAsync(new ShowtimeSpecification(status, query));
      var rows = await _uow.Showtimes.GetAllWithSpecAsync(
                         new ShowtimeSpecification(status, query, orderColumn, orderDir, request.Start, request.Length));

      var data = rows.Select(s => new ShowtimeListItemDto
      {
        Id = s.Id,
        MovieTitle = s.Movie.Title,
        MoviePoster = s.Movie.PosterPath,
        HallName = s.Hall.Name,
        TotalSeats = s.Hall.TotalSeats,
        StartTime = s.StartTime,
        EndTime = s.EndTime,
        Price = s.Price,
        Status = s.Status,
        TrailerKey = s.Movie.TrailerKey,
        TmdbId = s.Movie.TmdbId
      });

      return new { draw = request.Draw, recordsTotal = total, recordsFiltered = filtered, data };
    }

    // ── Create ───────────────────────────────────────────────────

    public async Task<string?> CreateAsync(ShowtimeCreateDto dto)
    {
      if (dto.StartTime < DateTime.Now)
        return "A showtime cannot be scheduled in the past.";

      if (dto.StartTime < DateTime.Now.AddHours(5))
        return "A showtime must be scheduled at least 5 hours from now.";

      var movie = await _uow.Movies.GetAsync(m => m.Id == dto.MovieId);
      if (movie is null) return "Movie not found.";

      var hall = await _uow.Halls.GetAsync(h => h.Id == dto.HallId);
      if (hall is null) return "Hall not found.";

      var endTime = dto.StartTime.AddMinutes((movie.RuntimeMinutes > 0 ? movie.RuntimeMinutes : 120) + BufferMinutes);

      if (await _uow.Showtimes.HasConflictAsync(dto.HallId, dto.StartTime, endTime))
        return $"{hall.Name} already has a showtime during that slot.";

      await _uow.Showtimes.CreateAsync(new Showtime
      {
        MovieId = dto.MovieId,
        HallId = dto.HallId,
        StartTime = dto.StartTime,
        EndTime = endTime,
        Price = dto.Price,
        Status = ShowtimeStatus.Scheduled,
      });

      await _uow.SaveAsync();
      return null;
    }

    // ── Halls dropdown ───────────────────────────────────────────

    public async Task<IEnumerable<HallDto>> GetHallsAsync()
    {
      var halls = await _uow.Halls.GetAllAsync();
      return halls.Select(h => new HallDto
      {
        Id = h.Id,
        Name = h.Name,
        TotalSeats = h.TotalSeats,
      });
    }

    public async Task<bool> UpdateStatusAsync(int id, ShowtimeStatus status)
    {
      var showtime = await _uow.Showtimes.GetAsync(s => s.Id == id);
      if (showtime == null) return false;

      showtime.Status = status;

      await _uow.Showtimes.UpdateAsync(showtime);
      await _uow.SaveAsync();

      return true;
    }
  }
}
