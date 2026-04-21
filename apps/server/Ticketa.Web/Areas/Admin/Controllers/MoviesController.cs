using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs;
using Ticketa.Core.Enums;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Interfaces.Services;
using Ticketa.Web.ViewModels;

namespace Ticketa.Web.Areas.Admin.Controllers
{
  [Area("Admin")]
  [Authorize]
  public class MoviesController : Controller
  {
    private readonly IMoviesService _movieService;
    private readonly ITmdbService _tmdbService;

    public MoviesController(IMoviesService movieService, ITmdbService tmdbService)
    {
      _movieService = movieService;
      _tmdbService = tmdbService;
    }

    public IActionResult Index() => View();

    public async Task<IActionResult> Import(CancellationToken cancellationToken)
    {
      var movies = await _tmdbService.GetPopularMoviesAsync(cancellationToken);
      return View(new MovieImportVM
      {
        AvailableMovies = movies.ToList()
      });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Import(MovieImportVM vm, CancellationToken cancellationToken)
    {
      if (vm.SelectedTmdbIds is null || !vm.SelectedTmdbIds.Any())
      {
        TempData["Error"] = "Please select at least one movie.";
        vm.AvailableMovies = (await _tmdbService.GetPopularMoviesAsync(cancellationToken)).ToList();
        return View(vm);
      }

      var result = await _movieService.ImportMoviesAsync(vm.SelectedTmdbIds, cancellationToken);

      if (result.ImportedTitles.Any())
        TempData["Success"] = $"Imported: {string.Join(", ", result.ImportedTitles)}";

      if (result.SkippedCount > 0)
        TempData["Warning"] = $"Skipped {result.SkippedCount} movie(s).";

      if (result.FailedCount > 0)
        TempData["Error"] = $"Failed to import {result.FailedCount} movie(s).";

      return RedirectToAction(nameof(Index));
    }

    [HttpGet]
    public async Task<IActionResult> SearchMovies(string query, CancellationToken cancellationToken)
    {
      if (string.IsNullOrWhiteSpace(query))
        return Json(new { });

      var results = await _movieService.SearchMoviesAsync(query, cancellationToken);
      return Json(results);
    }

    [HttpPost]
    public async Task<IActionResult> UpdateStatus(int id, int status)
    {
      var success = await _movieService.UpdateStatusAsync(id, (MovieStatus)status);

      if (!success)
        return Json(new { success = false, message = "Movie not found" });

      return Json(new { success = true });
    }

    public async Task<IActionResult> DeleteConfirmation(int id)
    {
      var movie = await _movieService.GetByIdAsync(id);

      if (movie is null)
        return NotFound();

      return PartialView("_DeleteMovieModal", movie);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
      var success = await _movieService.DeleteAsync(id);

      if (!success)
        return NotFound();

      TempData["success"] = "Movie deleted successfully";
      return Json(new { success = true });
    }

    [HttpGet]
    public async Task<IActionResult> GetAll(
        [FromQuery] DataTableRequestsDto request,
        [FromQuery(Name = "search[value]")] string? searchValue = null,
        [FromQuery(Name = "order[0][column]")] int orderColumn = 0,
        [FromQuery(Name = "order[0][dir]")] string orderDir = "asc",
        string? segmentedFilter = null)
    {
      var result = await _movieService.GetAllAsync(
          request,
          searchValue,
          orderColumn,
          orderDir,
          segmentedFilter);

      return Json(result);
    }

    [HttpGet]
    public async Task<IActionResult> GetTrailerKey(int tmdbId, CancellationToken cancellationToken)
    {
      var key = await _tmdbService.GetTrailerKeyAsync(tmdbId, cancellationToken);
      return Json(new { key });
    }
  }
}