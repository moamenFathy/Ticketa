using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Settings;

namespace Ticketa.API.Controllers
{
  [Route("api/[controller]")]
  [ApiController]
  public class AuthController(UserManager<AppUser> userManager, ITokenService tokenService, IOptions<JwtSettings> jwt) : ControllerBase
  {
    private readonly UserManager<AppUser> _userManager = userManager;
    private readonly ITokenService _tokenService = tokenService;
    private readonly JwtSettings _jwt = jwt.Value;

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginDto dto)
    {
      var user = await _userManager.FindByEmailAsync(dto.Email);

      if (user is null || !await _userManager.CheckPasswordAsync(user, dto.Password))
        return Unauthorized(new { message = "Invalid email or password" });
      if (!user.EmailConfirmed)
        return Unauthorized(new { message = "Please confirm your email before logging in" });

      var roles = await _userManager.GetRolesAsync(user);
      var accessToken = _tokenService.GenerateAccessToken(user, roles);
      var refreshToken = _tokenService.GenerateRefreshToken();

      user.RefreshToken = refreshToken;
      user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(_jwt.RefreshTokenExpiryDate);
      await _userManager.UpdateAsync(user);

      Response.Cookies.Append("refreshToken", refreshToken, new CookieOptions
      {
        HttpOnly = true,
        Secure = true,
        SameSite = SameSiteMode.Strict,
        Expires = DateTimeOffset.UtcNow.AddDays(_jwt.RefreshTokenExpiryDate)
      });

      // Here you would typically save the refresh token in the database associated with the user
      return Ok(new { accessToken });
    }

    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh()
    {
      var refreshToken = Request.Cookies["refreshToken"];
      if (string.IsNullOrEmpty(refreshToken))
        return Unauthorized();

      var user = await _userManager.Users.FirstOrDefaultAsync(u => u.RefreshToken == refreshToken);

      if (user is null || user.RefreshTokenExpiry <= DateTime.UtcNow)
        return Unauthorized("Refresh token expired.");

      var roles = await _userManager.GetRolesAsync(user);
      var accessToken = _tokenService.GenerateAccessToken(user, roles);
      user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(_jwt.RefreshTokenExpiryDate);
      await _userManager.UpdateAsync(user);

      return Ok(new { accessToken });
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout()
    {
      var refreshToken = Request.Cookies["refreshToken"];
      if (!string.IsNullOrEmpty(refreshToken))
      {
        var user = await _userManager.Users.FirstOrDefaultAsync(u => u.RefreshToken == refreshToken);

        if (user is not null)
        {
          user.RefreshToken = null;
          user.RefreshTokenExpiry = null;
          await _userManager.UpdateAsync(user);
        }
      }

      Response.Cookies.Delete("refreshToken");
      return NoContent();
    }
  }
}
