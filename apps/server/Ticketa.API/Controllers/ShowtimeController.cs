using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.Interfaces.IServices;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  public class ShowtimeController(IShowtimeService showtimeService) : ControllerBase
  {
    private readonly IShowtimeService _showtimeService = showtimeService;

    [HttpGet]
    public async Task<IActionResult> Get()
    {
      var showtimes = await _showtimeService.GetScheduledGroupedAsync();
      return Ok(showtimes);
    }
  }
}
