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
    public async Task<IActionResult> Import(MovieImportVM model)
    {
      var allMovies = await _tmdbService.GetPopularMoviesAsync();

      var selected = allMovies.FirstOrDefault(m => m.TmdbId == model.SelectedTmdbId);

      if (selected is null)
      {
        TempData["Error"] = "Please select a valid movie before importing.";
        model.AvailableMovies = allMovies.ToList();
        return View(model);
      }

      if (await _uow.Movies.ExistsByTmdbId(model.SelectedTmdbId))
      {
        TempData["Error"] = $"The movie '{selected.Title}' has already been imported.";
        model.AvailableMovies = allMovies.ToList();
        return View(model);
      }

      var movie = _mapper.Map<Movie>(selected);
      await _uow.Movies.CreateAsync(movie);
      await _uow.SaveAsync();

      TempData["Success"] = $"Successfully imported '{movie.Title}'!";
      return RedirectToAction(nameof(Import));
    }
  }
}
