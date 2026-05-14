using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IServices;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  public class ShowtimeController(IShowtimeService showtimeService) : ControllerBase
  {
    private readonly IShowtimeService _showtimeService = showtimeService;

    [HttpGet]
    [ProducesResponseType(typeof(MovieShowtimeDto), statusCode: StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ActiveMovieWithDetailsDto), statusCode: StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll()
    {
      try
      {
        var showtimes = await _showtimeService.GetScheduledGroupedAsync();
        return Ok(showtimes);
      }
      catch (OperationCanceledException ex)
      {
        return StatusCode(StatusCodes.Status503ServiceUnavailable, "The request was canceled. Please try again later.");
      }
      catch (Exception ex)
      {
        return StatusCode(StatusCodes.Status500InternalServerError, $"An error occurred while retrieving showtimes: {ex.Message}");)
      }
    }
  }
