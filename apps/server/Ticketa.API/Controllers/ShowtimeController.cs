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
    [ProducesResponseType(typeof(MovieShowtimeDto), statusCode: StatusCodes.Status499ClientClosedRequest)]
    [ProducesResponseType(typeof(MovieShowtimeDto), statusCode: StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll(CancellationToken ct)
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

    [HttpGet("{showtimeId:int}")]
    [ProducesResponseType(typeof(ShowtimeSeatDto), statusCode: StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ShowtimeSeatDto), statusCode: StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(MovieShowtimeDto), statusCode: StatusCodes.Status499ClientClosedRequest)]
    [ProducesResponseType(typeof(ShowtimeSeatDto), statusCode: StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetSeatMap(int showtimeId, CancellationToken ct)
    {
      try
      {
        var seatMap = await _showtimeService.GetSeatMapAsync(showtimeId, ct);
        if (seatMap == null)
          return NotFound($"No showtime found with id {showtimeId}");
        return Ok(seatMap);
      }
      catch (OperationCanceledException ex)
      {
        return StatusCode(StatusCodes.Status499ClientClosedRequest, $"The request was canceled. Please try again later: {ex.Message}");
      }
      catch (Exception ex)
      {
        return StatusCode(StatusCodes.Status500InternalServerError, $"An error occurred while retrieving the seat map: {ex.Message}");
      }
    }
  }
}
