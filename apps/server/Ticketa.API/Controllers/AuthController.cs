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
    private readonly IAuthApiService _authService = authService;
    private readonly JwtSettings _jwtSettings = jwt.Value;


    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var (success, error) = await _authService.RegisterAsync(dto, ct);
      if (!success) return BadRequest(new { message = error });

      return StatusCode(201, new { message = "Registration successful. Please check your email to confirm your account." });
    }

    [HttpPost("confirm-email")]
    public async Task<IActionResult> ConfirmEmail(ConfirmEmailDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);
      var result = await _authService.ConfirmEmailAsync(dto, ct);
      if (!result.Succeeded) return BadRequest(new { message = result.Message });

      AppendRefreshTokenCookie(result.RefreshToken!);
      return Ok(new { accessToken = result.AccessToken });
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var result = await _authService.LoginAsync(dto, ct);
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

      var result = await _authService.RefreshTokenAsync(refreshToken, ct);
      if (!result.Succeeded) return Unauthorized(result.Message);

      AppendRefreshTokenCookie(result.RefreshToken!);
      return Ok(new { accessToken = result.AccessToken });
    }

    [HttpPost("resend-confirmation")]
    public async Task<IActionResult> ResendConfirmation(ResendConfirmDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);
      await _authService.ResendEmailConfirmationAsync(dto.Email, ct);

      return Ok(new { message = "If that email is registered and unverified, a new code has been sent." });
    }

    [HttpPost("google")]
    public async Task<IActionResult> Google(GoogleAuthDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var result = await _authService.GoogleAuthAsync(dto.IdToken, ct);
      if (!result.Succeeded) return Unauthorized(new { message = result.Message });

      AppendRefreshTokenCookie(result.RefreshToken!);
      return Ok(new { accessToken = result.AccessToken });
    }

    [HttpPost("forget-password")]
    public async Task<IActionResult> ForgetPassword(ForgetPasswordDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      await _authService.ForgetPasswordAsync(dto.Email, ct);

      return Ok(new { message = "If that email is registered, a password reset link has been sent." });
    }

    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword(ResetPasswordDto dto, CancellationToken ct)
    {
      if (!ModelState.IsValid) return ValidationProblem(ModelState);

      var (success, error) = await _authService.ResetPasswordAsync(dto, ct);

      if (!success) return BadRequest(new { message = error });

      return Ok(new { message = "Password reset successful. You can now log in with your new password." });
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout(CancellationToken ct)
    {
      var refreshToken = Request.Cookies["refreshToken"];
      await _authService.LogoutAsync(refreshToken, ct);

      Response.Cookies.Delete("refreshToken");
      return NoContent();
    }

    private void AppendRefreshTokenCookie(string refreshToken)
    {
      Response.Cookies.Append("refreshToken", refreshToken, new CookieOptions
      {
        HttpOnly = true,
        Secure = true,
        SameSite = SameSiteMode.None,
        Expires = DateTimeOffset.UtcNow.AddDays(_jwtSettings.RefreshTokenExpiryDate)
      });
    }
  }
}
