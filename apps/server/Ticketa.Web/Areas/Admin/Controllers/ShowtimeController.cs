using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Web.ViewModels;

namespace Ticketa.Web.Areas.Admin.Controllers
{
  [Area("Admin")]
  [Authorize]
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
        [FromQuery(Name = "search[value]")] string? search,
        [FromQuery(Name = "order[0][column]")] int orderColumn = 0,
        [FromQuery(Name = "order[0][dir]")] string orderDir = "asc",
        string? segmentedFilter = null)
    {
      var result = await _showtimeService.GetAllAsync(
          request, search, orderColumn, orderDir, segmentedFilter);

      return Json(result);
    }

    [HttpGet]
    public async Task<IActionResult> Upsert(int? id)
    {
      var vm = new ShowtimeUpsertVM
      {
        Halls = await _showtimeService.GetHallsAsync(),
        Movies = await _moviesService.GetAllActiveAsync()
      };

      if (!id.HasValue)
        return PartialView("_CreateShowtimeModal", vm);

      var dto = await _showtimeService.GetForUpsertAsync(id.Value);
      if (dto == null)
        return NotFound();

      vm.Form = dto;
      return PartialView("_EditShowtimeModal", vm);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
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

    [HttpPost]
    public async Task<IActionResult> UpdateStatus(int id, Ticketa.Core.Enums.ShowtimeStatus status)
    {
      var success = await _showtimeService.UpdateStatusAsync(id, status);
      return Json(new { success });
    }

    [HttpGet]
    public async Task<IActionResult> DeleteConfirmation(int id)
    {
      var showtime = await _showtimeService.GetByIdAsync(id);

      if (showtime is null)
        return NotFound();

      return PartialView("_DeleteShowtimeModal", showtime);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
      var showtime = await _showtimeService.GetByIdAsync(id);
      if (showtime is null)
        return NotFound();

      var success = await _showtimeService.DeleteAsync(id);
      if (!success)
        return Json(new { success = false, message = "Failed to delete showtime." });

      TempData["success"] = "Showtime deleted successfully";
      return Json(new { success = true });
    }
  }
}
