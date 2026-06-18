using Google.Apis.Auth;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using System.Text;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Settings;

namespace Ticketa.Infrastructure.Service
{
  public class AuthApiService(IEmailService emailService, ITokenService tokenService, UserManager<AppUser> userManager, IOptions<JwtSettings> jwtSettings, IConfiguration config) : IAuthApiService
  {
    private readonly IEmailService _emailService = emailService;
    private readonly ITokenService _tokenService = tokenService;
    private readonly UserManager<AppUser> _userManager = userManager;
    private readonly JwtSettings _jwtSettings = jwtSettings.Value;
    private readonly IConfiguration _config = config;

    public async Task<AuthResultDto> ConfirmEmailAsync(ConfirmEmailDto dto, CancellationToken ct = default)
    {
      var user = await _userManager.FindByEmailAsync(dto.Email);

      if (user is null || user.VerificationCode != dto.Code || user.VerificationCodeExpiry < DateTime.UtcNow)
        return AuthResultDto.Failure("Invalid or expired verification code");

      user.EmailConfirmed = true;
      user.VerificationCode = null;
      user.VerificationCodeExpiry = null;
      await _userManager.UpdateAsync(user);

      var roles = await _userManager.GetRolesAsync(user);
      var token = _tokenService.GenerateAccessToken(user, roles);
      var refreshToken = _tokenService.GenerateRefreshToken();

      user.RefreshToken = refreshToken;
      user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpiryDate);
      await _userManager.UpdateAsync(user);

      return AuthResultDto.Success(token, refreshToken);
    }

    public async Task<AuthResultDto> GoogleAuthAsync(string idToken, CancellationToken ct = default)
    {
      GoogleJsonWebSignature.Payload payload;
      try
      {
        var settings = new GoogleJsonWebSignature.ValidationSettings
        {
          Audience = [_config["Google:ClientId"]]
        };
        payload = await GoogleJsonWebSignature.ValidateAsync(idToken, settings);
      }
      catch
      {
        return AuthResultDto.Failure("Invalid Google token.");
      }

      var user = await _userManager.FindByEmailAsync(payload.Email);

      if (user is null)
      {
        user = new AppUser
        {
          UserName = payload.Email,
          Email = payload.Email,
          EmailConfirmed = true,
          Theme = "light"
        };
        var result = await _userManager.CreateAsync(user);
        if (!result.Succeeded)
          return AuthResultDto.Failure("Failed to create user account.");
      }
      else if (!user.EmailConfirmed)
      {
        user.EmailConfirmed = true;
        await _userManager.UpdateAsync(user);
      }

      return await IssueTokensAsync(user);
    }

    public async Task<AuthResultDto> LoginAsync(LoginDto dto, CancellationToken ct = default)
    {
      var user = await _userManager.FindByEmailAsync(dto.Email);

      if (user is null || !await _userManager.CheckPasswordAsync(user, dto.Password))
        return AuthResultDto.Failure("Invalid email or password");

      if (!user.EmailConfirmed)
        return AuthResultDto.Failure("Email not confirmed. Please check your inbox.");

      return await IssueTokensAsync(user);
    }

    public async Task LogoutAsync(string? refreshToken, CancellationToken ct = default)
    {
      if (string.IsNullOrWhiteSpace(refreshToken)) return;

      var user = _userManager.Users.FirstOrDefault(u => u.RefreshToken == refreshToken);

      if (user is null)
        return;

      user.RefreshToken = null;
      user.RefreshTokenExpiry = null;
      await _userManager.UpdateAsync(user);
    }

    public async Task<(bool success, string? Error)> RegisterAsync(RegisterDto dto, CancellationToken ct = default)
    {
      var existing = await _userManager.FindByEmailAsync(dto.Email);

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

      var result = await _userManager.CreateAsync(user, dto.Password);

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
      var user = _userManager.Users.FirstOrDefault(u => u.RefreshToken == refreshToken);

      if (user is null || user.RefreshTokenExpiry < DateTime.UtcNow)
        return AuthResultDto.Failure("Invalid or expired refresh token");

      return await IssueTokensAsync(user);
    }

    public async Task ResendEmailConfirmationAsync(string email, CancellationToken ct = default)
    {
      var user = await _userManager.FindByEmailAsync(email);

      if (user is null || user.EmailConfirmed) return;

      await SendVerificationCodeAsync(user);
    }

    private async Task<AuthResultDto> IssueTokensAsync(AppUser user)
    {
      var roles = await _userManager.GetRolesAsync(user);
      var accessToken = _tokenService.GenerateAccessToken(user, roles);
      var refreshToken = _tokenService.GenerateRefreshToken();

      var expiryDays = _jwtSettings.RefreshTokenExpiryDate;
      user.RefreshToken = refreshToken;
      user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(expiryDays);
      await _userManager.UpdateAsync(user);

      return AuthResultDto.Success(accessToken, refreshToken);
    }

    private async Task SendVerificationCodeAsync(AppUser user)
    {
      var code = GenerateSixDigitCode();
      user.VerificationCode = code;
      user.VerificationCodeExpiry = DateTime.UtcNow.AddMinutes(15);
      await _userManager.UpdateAsync(user);

      var emailBody = EmailTemplates.VerificationCode(code);
      await _emailService.SendEmailAsync(user.Email!, "Verify Your Email", emailBody);
    }
    public async Task ForgetPasswordAsync(string email, CancellationToken ct = default)
    {
      var user = await _userManager.FindByEmailAsync(email);

      if (user is null || !user.EmailConfirmed) return;

      var token = await _userManager.GeneratePasswordResetTokenAsync(user);

      var encodedToken = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(token));

      var clientUrl = _config["ClientSettings:BaseUrl"];

      var resetLink = $"{clientUrl}/reset-password" +
              $"?email={Uri.EscapeDataString(user.Email!)}&token={Uri.EscapeDataString(encodedToken)}";

      var html = EmailTemplates.PasswordReset(user.UserName!, resetLink);

      await _emailService.SendEmailAsync(user.Email!, "Reset Your Password", html);
    }

    public async Task<(bool Success, string? Error)> ResetPasswordAsync(ResetPasswordDto dto, CancellationToken ct = default)
    {
      var user = await _userManager.FindByEmailAsync(dto.Email);

      if (user is null)
        return (false, "Invalid email address.");

      string decodedToken;

      try
      {
        decodedToken = Encoding.UTF8.GetString(WebEncoders.Base64UrlDecode(dto.Token));
      }
      catch (Exception ex)
      {
        return (false, "Invalid token format.");
      }

      var result = await _userManager.ResetPasswordAsync(user, decodedToken, dto.NewPassword);

      if (!result.Succeeded)
      {
        return (false, result.Errors.First().Description);
      }

      return (true, null);
    }

    private static string GenerateSixDigitCode() => Random.Shared.Next(100_000, 999_999).ToString();

  }
}
