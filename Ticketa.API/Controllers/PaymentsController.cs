using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IServices;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  public class PaymentsController(IPaymentService paymentService) : ControllerBase
  {
    private readonly IPaymentService _paymentService = paymentService;

    [HttpPost("create-intent")]
    public async Task<IActionResult> CreateIntent(CreatePaymentIntentDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var userId = User.FindFirstValue("uid");
      var result = await _paymentService.CreateIntentAsync(dto, userId!, ct);

      return result is null ? NotFound(new { message = "showtime not found." }) : Ok(result);
    }

    public async Task<IActionResult> Confirm(ConfirmPaymentDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var userId = User.FindFirstValue("uid");
      var result = await _paymentService.ConfirmAsync(dto.PaymentIntentId, userId!, ct);

      if (!result.Succeeded && result.ConflictingSeats.Count > 0)
        return BadRequest(new { message = result.Message, conflictingSeats = result.ConflictingSeats });

      return Ok(result);
    }
  }
}
