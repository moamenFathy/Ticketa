using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Settings;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  public class AuthController(IAuthApiService authService, IOptions<JwtSettings> jwt) : ControllerBase
  {
    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var (success, error) = await authService.RegisterAsync(dto, ct);
      if (!success) return BadRequest(new { message = error });

      return StatusCode(201, new { message = "Registration successful. Please check your email to confirm your account." });
    }

    [HttpPost("confirm-email")]
    public async Task<IActionResult> ConfirmEmail(ConfirmEmailDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);
      var result = await authService.ConfirmEmailAsync(dto, ct);
      if (!result.Succeeded) return BadRequest(new { message = result.Message });

      AppendRefreshTokenCookie(result.RefreshToken!);
      return Ok(new { accessToken = result.AccessToken });
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var result = await authService.LoginAsync(dto, ct);
      if (!result.Succeeded) return Unauthorized(new { message = result.Message });

      AppendRefreshTokenCookie(result.RefreshToken!);
      return Ok(new { accessToken = result.AccessToken });
    }

    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh(CancellationToken ct)
    {
      var refreshToken = Request.Cookies["refreshToken"];
      if (string.IsNullOrEmpty(refreshToken))
        return Unauthorized();

      var result = await authService.RefreshTokenAsync(refreshToken, ct);
      if (!result.Succeeded) return Unauthorized(result.Message);

      AppendRefreshTokenCookie(result.RefreshToken!);
      return Ok(new { accessToken = result.AccessToken });
    }

    [HttpPost("resend-confirmation")]
    public async Task<IActionResult> ResendConfirmation(ResendConfirmDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);
      await authService.ResendEmailConfirmationAsync(dto.Email, ct);

      return Ok(new { message = "If that email is registered and unverified, a new code has been sent." });
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout(CancellationToken ct)
    {
      var refreshToken = Request.Cookies["refreshToken"];
      await authService.LogoutAsync(refreshToken, ct);

      Response.Cookies.Delete("refreshToken");
      return NoContent();
    }

    private void AppendRefreshTokenCookie(string refreshToken)
    {
      Response.Cookies.Append("refreshToken", refreshToken, new CookieOptions
      {
        HttpOnly = true,
        Secure = true,
        SameSite = SameSiteMode.Strict,
        Expires = DateTimeOffset.UtcNow.AddDays(jwt.Value.RefreshTokenExpiryDate)
      });
    }
  }
}
