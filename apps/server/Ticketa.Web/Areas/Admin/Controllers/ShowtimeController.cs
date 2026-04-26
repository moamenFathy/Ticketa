using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Web.ViewModels;

namespace Ticketa.Web.Areas.Admin.Controllers
{
  [Area("Admin")]
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
    public async Task<IActionResult> Create()
    {
      var vm = new ShowtimeCreateVM
      {
        Halls = await _showtimeService.GetHallsAsync(),
        Movies = await _moviesService.GetAllActiveAsync()
      };

      return PartialView("_CreateShowtimeModal", vm);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind(Prefix = "Form")] ShowtimeCreateDto dto)
    {
      if (!ModelState.IsValid)
      {
        var vm = new ShowtimeCreateVM
        {
          Form = dto,
          Halls = await _showtimeService.GetHallsAsync(),
          Movies = await _moviesService.GetAllActiveAsync(),
        };
        return PartialView("_CreateShowtimeModal", vm);
      }

      var error = await _showtimeService.CreateAsync(dto);

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

  }
}
