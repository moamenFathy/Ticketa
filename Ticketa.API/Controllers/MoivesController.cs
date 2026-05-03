using Microsoft.AspNetCore.Mvc;
using System.Net;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IServices;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  public class MoviesController(IMoviesService moviesService) : ControllerBase
  {
    private readonly IMoviesService _moviesService = moviesService;

    [HttpGet]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll(CancellationToken ct)
    {
      try
      {
        var movies = await _moviesService.GetAllActiveWithDetailsAsync(ct);
        return Ok(movies);
      }
      catch (Exception ex)
      {
        // Log the exception (not implemented here)
        return StatusCode((int)HttpStatusCode.InternalServerError, $"An error occurred while retrieving movies: {ex.Message}");
      }
    }

    [HttpGet("{id:int}")]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Get(int id, CancellationToken ct)
    {
      try
      {
        if (id <= 0)
          return BadRequest("The id must be greater than 0");

        var movie = await _moviesService.GetActiveMovieWithDetailsByIdAsync(id, ct);

        if (movie == null)
          return NotFound("The movie with this id not exist");

        return Ok(movie);
      }
      catch (Exception ex)
      {
        return StatusCode((int)HttpStatusCode.InternalServerError, $"An error occurred while retrieving the movie: {ex.Message}");
      }
    }
  }
}