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

    public async Task<IEnumerable<MovieShowtimeDto>> GetAllAsync(
        string? search,
        string? segmentedFilter)
    {
      ShowtimeStatus? status = segmentedFilter?.ToLower() switch
      {
        "scheduled" => ShowtimeStatus.Scheduled,
        "soldout" => ShowtimeStatus.SoldOut,
        "completed" => ShowtimeStatus.Completed,
        _ => null
      };

      var query = string.IsNullOrWhiteSpace(search) ? null : search;

      var showtimes = await _uow.Showtimes.GetAllWithSpecAsync(
          new ShowtimeSpecification(status, query));

      return showtimes
          .GroupBy(s => s.Movie)
          .Select(g => new MovieShowtimeDto
          {
            MovieId = g.Key.Id,
            TmdbId = g.Key.TmdbId,
            Title = g.Key.Title,
            PosterPath = g.Key.PosterPath,
            trailerKey = g.Key.TrailerKey,
            Showtimes = g.Select(s => new ShowtimeListItemDto
            {
              Id = s.Id,
              HallName = s.Hall.Name,
              TotalSeats = s.Hall.TotalSeats,
              StartTime = s.StartTime,
              EndTime = s.EndTime,
              Price = s.Price,
              Status = s.Status,
              HallId = s.HallId
            }).OrderBy(s => s.StartTime).ToList()
          })
          .OrderBy(m => m.Title);
    }
    // ── Create & Update ───────────────────────────────────────────────────

    public async Task<string?> CreateAsync(ShowtimeUpsertDto dto)
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

    public async Task<Showtime?> GetByIdAsync(int id)
    {
      var spec = new ShowtimeByIdSpecification(id);
      var showtimes = await _uow.Showtimes.GetAllWithSpecAsync(spec);
      return showtimes.FirstOrDefault();
    }

    public async Task<ShowtimeUpsertDto?> GetForUpsertAsync(int id)
    {
      var showtime = await GetByIdAsync(id);
      if (showtime == null) return null;

      return new ShowtimeUpsertDto
      {
        Id = showtime.Id,
        MovieId = showtime.MovieId,
        HallId = showtime.HallId,
        StartTime = showtime.StartTime,
        Price = showtime.Price
      };
    }

    public async Task<string?> UpdateAsync(ShowtimeUpsertDto dto)
    {
      if (dto.StartTime < DateTime.Now)
        return "A showtime cannot be scheduled in the past.";

      if (dto.StartTime < DateTime.Now.AddHours(5))
        return "A showtime must be scheduled at least 5 hours from now.";

      var movie = await _uow.Movies.GetAsync(m => m.Id == dto.MovieId);
      if (movie is null) return "Movie not found.";

      var hall = await _uow.Halls.GetAsync(h => h.Id == dto.HallId);
      if (hall is null) return "Hall not found.";

      var showtime = await _uow.Showtimes.GetAsync(s => s.Id == dto.Id);
      if (showtime is null) return "Showtime not found.";

      if (showtime.StartTime <= DateTime.Now.AddHours(5))
        return "A showtime cannot be edited less than 5 hours before it starts.";

      if (showtime.Status == ShowtimeStatus.Completed)
        return "The showtime is already completed";

      var endTime = dto.StartTime.AddMinutes((movie.RuntimeMinutes > 0 ? movie.RuntimeMinutes : 120) + BufferMinutes);

      if (await _uow.Showtimes.HasConflictAsync(dto.HallId, dto.StartTime, endTime, dto.Id))
        return $"{hall.Name} already has a showtime during that slot.";

      showtime.MovieId = dto.MovieId;
      showtime.HallId = dto.HallId;
      showtime.StartTime = dto.StartTime;
      showtime.EndTime = endTime;
      showtime.Price = dto.Price;

      await _uow.Showtimes.UpdateAsync(showtime);
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
        Type = h.Type,
        TotalRows = h.TotalRows,
        SeatsPerRow = h.SeatsPerRow,
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

    public async Task<IEnumerable<MovieShowtimeDto>> GetScheduledGroupedAsync(CancellationToken ct = default)
    {
      return await GetAllAsync(search: null, segmentedFilter: "scheduled");
    }

    public async Task<bool> DeleteAsync(int id)
    {
      var showtime = await _uow.Showtimes.GetAsync(s => s.Id == id);

      if (showtime is null)
        return false;

      if (showtime.Status != ShowtimeStatus.Completed)
        return false;

      _uow.Showtimes.Delete(showtime);
      await _uow.SaveAsync();

      return true;
    }
  }
}
