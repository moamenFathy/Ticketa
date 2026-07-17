using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs;
using Ticketa.Core.DTOs.Common;
using Ticketa.Core.Interfaces.IServices;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  public class MoviesController(IMoviesService moviesService, IShowtimeService showtimeService) : ControllerBase
  {
    private readonly IMoviesService _moviesService = moviesService;
    private readonly IShowtimeService _showtimeService = showtimeService;

    [HttpGet]
    [ProducesResponseType(typeof(PagedResultDto<ActiveMovieWithDetailsDto>), statusCode: StatusCodes.Status200OK)]
    [ProducesResponseType(statusCode: StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll([FromQuery] int page = 1, [FromQuery] int pageSize = 10, CancellationToken ct = default)
    {
      try
      {
        var result = await _moviesService.GetAllActiveWithDetailsAsync(page, pageSize, ct);
        return Ok(result);
      }
      catch (OperationCanceledException)
      {
        return StatusCode(StatusCodes.Status499ClientClosedRequest, "The request was canceled.");
      }
      catch (Exception ex)
      {
        return StatusCode(StatusCodes.Status500InternalServerError, $"An error occurred while retrieving movies: {ex.Message}");
      }
    }

    [HttpGet("NowShowing")]
    [ProducesResponseType(typeof(MovieShowtimeDto), statusCode: StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(MovieShowtimeDto), statusCode: StatusCodes.Status499ClientClosedRequest)]
    [ProducesResponseType(typeof(MovieShowtimeDto), statusCode: StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetNowShowing(CancellationToken ct)
    {
      try
      {
        var showtimes = await _showtimeService.GetScheduledGroupedAsync(ct);
        return Ok(showtimes);
      }
      catch (OperationCanceledException ex)
      {
        return StatusCode(StatusCodes.Status499ClientClosedRequest, $"The request was canceled. Please try again later: {ex.Message}");
      }
      catch (Exception ex)
      {
        return StatusCode(StatusCodes.Status500InternalServerError, $"An error occurred while retrieving showtimes: {ex.Message}");
      }
    }

    [HttpGet("coming-soon")]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetComingSoon(CancellationToken ct)
    {
      try
      {
        var movies = await _moviesService.GetComingSoonMoviesAsync(ct);
        return Ok(movies);
      }
      catch (OperationCanceledException)
      {
        return StatusCode(StatusCodes.Status499ClientClosedRequest, "The request was canceled.");
      }
      catch (Exception ex)
      {
        return StatusCode(StatusCodes.Status500InternalServerError, $"An error occurred while retrieving coming soon movies: {ex.Message}");
      }
    }

    [HttpGet("top-booked")]
    [ProducesResponseType(typeof(TopBookedMovieDto), statusCode: StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(TopBookedMovieDto), statusCode: StatusCodes.Status500InternalServerError)]
    [ProducesResponseType(typeof(TopBookedMovieDto), statusCode: StatusCodes.Status499ClientClosedRequest)]
    public async Task<IActionResult> GetTopBookings([FromQuery] int count = 6, CancellationToken ct = default)
    {
      try
      {
        var topBookedMovies = await _moviesService.GetTopBookedMoviesAsync(count, ct);
        return Ok(topBookedMovies);
      }
      catch (OperationCanceledException)
      {
        return StatusCode(StatusCodes.Status499ClientClosedRequest, "The request was canceled.");
      }
      catch (Exception ex)
      {
        return StatusCode(StatusCodes.Status500InternalServerError, $"An error occurred while retrieving top booked movies: {ex.Message}");
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
      catch (OperationCanceledException)
      {
        return StatusCode(StatusCodes.Status499ClientClosedRequest, "The request was canceled.");
      }
      catch (Exception ex)
      {
        return StatusCode(StatusCodes.Status500InternalServerError, $"An error occurred while retrieving the movie: {ex.Message}");
      }
    }
  }
}