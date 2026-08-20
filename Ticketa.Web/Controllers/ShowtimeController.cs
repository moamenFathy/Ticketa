using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Authorization;
using Ticketa.Web.ViewModels;
using static Ticketa.Core.Helpers.Permissions;

namespace Ticketa.Web.Controllers
{
  [RequirePermission(Showtimes.View)]
  public class ShowtimeController : Controller
  {
    private readonly IShowtimeService _showtimeService;
    private readonly IMoviesService _moviesService;

    public ShowtimeController(IShowtimeService showtimeService, IMoviesService moviesService)
    {
      _showtimeService = showtimeService;
      _moviesService = moviesService;
    }

    public IActionResult Index() => View();

    [HttpGet]
    public async Task<IActionResult> GetAll(
    [FromQuery] DataTableRequestsDto request,
    [FromQuery(Name = "search[value]")] string? searchValue = null,
    string? segmentedFilter = null)
    {
      var result = await _showtimeService.GetAllAsync(request, searchValue, segmentedFilter);
      return Json(result);
    }

    [HttpGet]
    public async Task<IActionResult> Upsert(int? id, int? hallId)
    {
      var vm = new ShowtimeUpsertVM
      {
        Halls = await _showtimeService.GetHallsAsync(),
        Movies = await _moviesService.GetAllActiveAsync()
      };

      if (id.HasValue)
      {
        var dto = await _showtimeService.GetForUpsertAsync(id.Value);
        if (dto == null)
          return NotFound();
        vm.Form = dto;
        return PartialView("_EditShowtimeModal", vm);
      }

      if (hallId.HasValue)
      {
        vm.Form = new ShowtimeUpsertDto { HallId = hallId.Value };
      }

      return PartialView("_CreateShowtimeModal", vm);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequirePermission(Showtimes.Edit)]
    public async Task<IActionResult> Upsert([Bind(Prefix = "Form")] ShowtimeUpsertDto dto)
    {
      var viewName = dto.Id == 0 ? "_CreateShowtimeModal" : "_EditShowtimeModal";

      if (!ModelState.IsValid)
      {
        var vm = new ShowtimeUpsertVM
        {
          Form = dto,
          Halls = await _showtimeService.GetHallsAsync(),
          Movies = await _moviesService.GetAllActiveAsync(),
        };
        return PartialView(viewName, vm);
      }

      string? error;
      if (dto.Id == 0)
        error = await _showtimeService.CreateAsync(dto);
      else
        error = await _showtimeService.UpdateAsync(dto);

      if (error is not null)
        return Json(new { success = false, message = error });

      return Json(new { success = true });
    }

    [HttpGet]
    public async Task<IActionResult> ViewSeatMap(int id)
    {
      var seatMap = await _showtimeService.GetSeatMapAsync(id);
      if (seatMap is null)
        return NotFound();

      return PartialView("_ViewHallMapModal", seatMap);
    }

    [HttpGet]
    [RequirePermission(Showtimes.Delete)]
    public async Task<IActionResult> DeleteConfirmation(int id)
    {
      var showtime = await _showtimeService.GetByIdAsync(id);

      if (showtime is null)
        return NotFound();

      return PartialView("_DeleteShowtimeModal", showtime);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequirePermission(Showtimes.Delete)]
    public async Task<IActionResult> Delete(int id)
    {
      var error = await _showtimeService.DeleteAsync(id);
      if (error is not null)
        return Json(new { success = false, message = error });

      TempData["success"] = "Showtime deleted successfully";
      return Json(new { success = true });
    }

    [HttpGet]
    public async Task<IActionResult> GetByDate(string date, CancellationToken ct)
    {
      if (!DateOnly.TryParse(date, out var parsed))
        return BadRequest("Invalid date.");

      var result = await _showtimeService.GetByDateAsync(parsed, ct);
      return Json(result);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequirePermission(Showtimes.Edit)]
    public async Task<IActionResult> SaveBatch([FromBody] ShowtimeBatchSaveDto dto, CancellationToken ct)
    {
      if (dto.Changes is null || dto.Changes.Count == 0)
        return Json(new ShowtimeBatchResultDto { Success = true });

      var result = await _showtimeService.SaveBatchAsync(dto, ct);
      return Json(result);
    }

    [HttpGet]
    public async Task<IActionResult> ActiveMoviesDropdown()
    {
      var movies = await _moviesService.GetAllActiveAsync();
      return Json(movies);
    }
  }
}
