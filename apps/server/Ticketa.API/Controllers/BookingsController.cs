using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IRepositories;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  [Authorize]
  public class BookingsController(IBookingService bookingService) : ControllerBase
  {
    private readonly IBookingService _boookingService = bookingService;

    [HttpPost]
    public async Task<IActionResult> Book(BookingCreateDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var userId = User.FindFirstValue("uid")!;
      var result = await _boookingService.CreateAsync(dto, userId, ct);

      if (!result.Succeeded)
        return Conflict(new { message = $"{result.ConflictingSeats.Count} seat(s) already booked.", conflictingSeats = result.ConflictingSeats });

      return Ok(new
      {
        bookingReference = result.BookingReference,
        totalAmount = result.TotalAmount
      });
    }
  }
}
