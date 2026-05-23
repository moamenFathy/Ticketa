using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Settings;

namespace Ticketa.Infrastructure.Service
{
  public class AuthApiService(IEmailService emailService, ITokenService tokenService, UserManager<AppUser> userManager, IOptions<JwtSettings> jwtSettings) : IAuthApiService
  {
    public async Task<AuthResultDto> ConfirmEmailAsync(ConfirmEmailDto dto, CancellationToken ct = default)
    {
      var user = await userManager.FindByEmailAsync(dto.Email);

      if (user is null || user.VerificationCode != dto.Code || user.VerificationCodeExpiry < DateTime.UtcNow)
        return AuthResultDto.Failure("Invalid or expired verification code");

      user.EmailConfirmed = true;
      user.VerificationCode = null;
      user.VerificationCodeExpiry = null;
      await userManager.UpdateAsync(user);

      var roles = await userManager.GetRolesAsync(user);
      var token = tokenService.GenerateAccessToken(user, roles);
      var refreshToken = tokenService.GenerateRefreshToken();

      user.RefreshToken = refreshToken;
      user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(jwtSettings.Value.RefreshTokenExpiryDate);
      await userManager.UpdateAsync(user);

      return AuthResultDto.Success(token, refreshToken);
    }

    public async Task<AuthResultDto> LoginAsync(LoginDto dto, CancellationToken ct = default)
    {
      var user = await userManager.FindByEmailAsync(dto.Email);

      if (user is null || !await userManager.CheckPasswordAsync(user, dto.Password))
        return AuthResultDto.Failure("Invalid email or password");

      if (!user.EmailConfirmed)
        return AuthResultDto.Failure("Email not confirmed. Please check your inbox.");

      var roles = await userManager.GetRolesAsync(user);
      var accessToken = tokenService.GenerateAccessToken(user, roles);
      var refreshToken = tokenService.GenerateRefreshToken();

      user.RefreshToken = refreshToken;
      user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(jwtSettings.Value.RefreshTokenExpiryDate);
      await userManager.UpdateAsync(user);

      return AuthResultDto.Success(accessToken, refreshToken);
    }

    public async Task LogoutAsync(string? refreshToken, CancellationToken ct = default)
    {
      if (string.IsNullOrWhiteSpace(refreshToken)) return;

      var user = userManager.Users.FirstOrDefault(u => u.RefreshToken == refreshToken);

      if (user is null)
        return;

      user.RefreshToken = null;
      user.RefreshTokenExpiry = null;
      await userManager.UpdateAsync(user);
    }

    public async Task<(bool success, string? Error)> RegisterAsync(RegisterDto dto, CancellationToken ct = default)
    {
      var existing = await userManager.FindByEmailAsync(dto.Email);

      if (existing is not null)
      {
        if (existing.EmailConfirmed)
          return (false, "Email is already registered and confirmed.");

        await SendVerificationCodeAsync(existing);
        return (true, null);
      }

      var user = new AppUser
      {
        UserName = dto.Email,
        Email = dto.Email,
        DateOfBirth = dto.DateOfBirth,
        Theme = "light"
      };

      var result = await userManager.CreateAsync(user, dto.Password);

      if (!result.Succeeded)
      {
        var errors = result.Errors.First().Description;
        return (false, errors);
      }

      await SendVerificationCodeAsync(user);
      return (true, null);
    }

    public async Task<AuthResultDto> RefreshTokenAsync(string refreshToken, CancellationToken ct = default)
    {
      var user = userManager.Users.FirstOrDefault(u => u.RefreshToken == refreshToken);

      if (user is null || user.RefreshTokenExpiry < DateTime.UtcNow)
        return AuthResultDto.Failure("Invalid or expired refresh token");

      var roles = await userManager.GetRolesAsync(user);
      var newAccessToken = tokenService.GenerateAccessToken(user, roles);
      var newRefreshToken = tokenService.GenerateRefreshToken();

      user.RefreshToken = newRefreshToken;
      user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(jwtSettings.Value.RefreshTokenExpiryDate);
      await userManager.UpdateAsync(user);

      return AuthResultDto.Success(newAccessToken, newRefreshToken);
    }

    public async Task ResendEmailConfirmationAsync(string email, CancellationToken ct = default)
    {
      var user = await userManager.FindByEmailAsync(email);

      if (user is null || user.EmailConfirmed) return;

      await SendVerificationCodeAsync(user);
    }

    private async Task SendVerificationCodeAsync(AppUser user)
    {
      var code = GenerateSixDigitCode();
      user.VerificationCode = code;
      user.VerificationCodeExpiry = DateTime.UtcNow.AddMinutes(15);
      await userManager.UpdateAsync(user);

      var emailBody = EmailTemplates.VerificationCode(code);
      await emailService.SendEmailAsync(user.Email!, "Verify Your Email", emailBody);
    }

    private static string GenerateSixDigitCode() => Random.Shared.Next(100_000, 999_999).ToString();
  }
}
