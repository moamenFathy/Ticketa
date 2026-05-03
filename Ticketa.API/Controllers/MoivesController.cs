using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.Interfaces.IServices;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  public class MoviesController(IMoviesService moviesService) : ControllerBase
  {
    private readonly IMoviesService _moviesService = moviesService;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
      var movies = await _moviesService.GetAllActiveWithDetailsAsync();
      return Ok(movies);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
      var movie = await _moviesService.GetActiveMovieWithDetailsByIdAsync(id);

      if (movie == null)
        return NotFound();
      return Ok(movie);
    }
  }
}