using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.Services;
using Ticketa.Web.ViewModels;

namespace Ticketa.Web.Areas.Admin.Controllers
{
  [Area("Admin")]
  [Authorize]
  public class MoviesController : Controller
  {
    private readonly IUnitOfWork _uow;
    private readonly ITmdbService _tmdbService;
    private readonly IMapper _mapper;

    public MoviesController(IUnitOfWork uow, ITmdbService tmdbService, IMapper mapper)
    {
      _uow = uow;
      _tmdbService = tmdbService;
      _mapper = mapper;
    }

    public IActionResult Index()
    {
      return View();
    }

    public async Task<IActionResult> Import()
    {
      var movies = await _tmdbService.GetPopularMoviesAsync();
      var vm = new MovieImportVM { AvailableMovies = movies.ToList() };
      return View(vm);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Import(MovieImportVM vm, CancellationToken cancellationToken)
    {
      if (vm.SelectedTmdbIds is null || vm.SelectedTmdbIds.Count == 0)
      {
        TempData["Error"] = "Please select at least one movie.";
        vm.AvailableMovies = (await _tmdbService.GetPopularMoviesAsync(cancellationToken)).ToList();
        return View(vm);
      }

      var selectedIds = vm.SelectedTmdbIds.Distinct().ToList();
      var existingIds = await _uow.Movies.ExistingTmdbIdsAsync(selectedIds);
      var idsToImport = selectedIds.Where(id => !existingIds.Contains(id)).ToList();

      var moviesToAdd = new List<Movie>();
      var failedIds = new List<int>();

      foreach (var tmdbId in idsToImport)
      {
        // 1. Call the service (which is now safe)
        var movieDetails = await _tmdbService.GetMovieDetailAsync(tmdbId, cancellationToken);
        // 2. VALIDATION: Check if the returned object is empty/invalid
        // If the service returned a 'new TmdbMovieDetailDto()', the ID will be 0
        if (movieDetails == null || movieDetails.TmdbId == 0)
        {
            failedIds.Add(tmdbId); // Mark this specific movie as failed
            continue;              // Skip to the next movie, don't crash the loop!
        }
        // 3. Only map and save if the data is actually valid
        var movie = _mapper.Map<Movie>(movieDetails);
        movie.TrailerKey = await _tmdbService.GetTrailerKeyAsync(tmdbId, cancellationToken);
        moviesToAdd.Add(movie);
      }

      if (moviesToAdd.Count > 0)
      {
        await _uow.Movies.CreateRangeAsync(moviesToAdd);
        await _uow.SaveAsync();
      }

      if (moviesToAdd.Count > 0)
        TempData["Success"] = $"Imported: {string.Join(", ", moviesToAdd.Select(m => m.Title))}";

      if (existingIds.Count > 0)
        TempData["Warning"] = $"Skipped {existingIds.Count} movie(s) because they already exist.";

      if (failedIds.Count > 0)
        TempData["Error"] = $"Could not fetch {failedIds.Count} selected movie(s) from TMDB.";

      return RedirectToAction(nameof(Index));
    }

    [HttpGet]
    public async Task<IActionResult> SearchMovies(string query, CancellationToken cancellationToken)
    {
      if (string.IsNullOrWhiteSpace(query))
        return Json(new List<object>());

      var results = await _tmdbService.SearchMoviesAsync(query, cancellationToken);

      var mapped = results.Select(m => new
      {
        value = m.TmdbId,
        text = m.Title,
        year = m.ReleaseDate?.Length >= 4 ? m.ReleaseDate[..4] : "N/A",
        rating = m.VoteAverage.ToString("F1"),
        poster = m.PosterPath,
        overview = m.Overview
      });

      return Json(mapped);
    }

    [HttpPost]
    public async Task<IActionResult> UpdateStatus(int id, int status)
    {
      var movie = await _uow.Movies.GetAsync(m => m.Id == id);
      if (movie == null)
      {
        return Json(new { success = false, message = "Movie not found" });
      }

      movie.Status = (Core.Enums.MovieStatus)status;

      await _uow.Movies.UpdateAsync(movie);
      await _uow.SaveAsync();

      return Json(new { success = true });
    }

    public async Task<IActionResult> DeleteConfirmation(int id)
    {
      var movie = await _uow.Movies.GetAsync(m => m.Id == id);

      if (movie is null)
      {
        return NotFound();
      }

      return PartialView("_DeleteMovieModal", movie);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
      var movie = await _uow.Movies.GetAsync(m => m.Id == id);

      if (movie is null)
      {
        TempData["Error"] = "The Movie Not Found";
        return NotFound();
      }

      _uow.Movies.Delete(movie);
      await _uow.SaveAsync();
      TempData["success"] = "Movie deleted successfully";
      return Json(new { success = true });
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
      var movies = await _uow.Movies.GetAllAsync();
      return Json(new { data = movies });
    }

    [HttpGet]
    public async Task<IActionResult> GetTrailerKey(int tmdbId, CancellationToken cancellationToken)
    {
      var key = await _tmdbService.GetTrailerKeyAsync(tmdbId, cancellationToken);
      return Json(new { key });
    }
  }
}
