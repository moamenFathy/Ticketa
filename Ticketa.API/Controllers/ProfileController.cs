using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Ticketa.Core.DTOs.Profile;
using Ticketa.Core.Interfaces.IServices;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  [Authorize]
  public class ProfileController(IProfileService profileService) : ControllerBase
  {
    private readonly IProfileService _profileService = profileService;

    [HttpGet]
    public async Task<IActionResult> GetProfile(CancellationToken ct)
    {
      var userId = User.FindFirstValue("uid");
      var profile = await _profileService.GetProfileAsync(userId!, ct);
      return profile is null ? NotFound(new { message = "User not found." }) : Ok(profile);
    }

    [HttpPut]
    public async Task<IActionResult> UpdateProfile(ProfileUpdateDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var userId = User.FindFirstValue("uid");
      var (success, errors) = await _profileService.UpdateProfileAsync(userId!, dto, ct);
      return success ? Ok() : BadRequest(new { errors });
    }

    [HttpPut("password")]
    public async Task<IActionResult> ChangePassword(ChangePasswordDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var userId = User.FindFirstValue("uid");
      var (success, errors) = await _profileService.ChangePasswordAsync(userId!, dto, ct);
      return success ? Ok() : BadRequest(new { errors });
    }

    [HttpGet("bookings")]
    public async Task<IActionResult> GetBookingHistory(
        CancellationToken ct, [FromQuery] int page = 1, [FromQuery] int pageSize = 10)
    {
      if (page < 1) page = 1;
      if (pageSize < 1) pageSize = 10;

      var userId = User.FindFirstValue("uid");
      var result = await _profileService.GetBookingHistoryAsync(userId!, page, pageSize, ct);
      return Ok(result);
    }
  }
}
