using Microsoft.AspNetCore.Identity;
using System.Security.Cryptography;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Service;

public class AuthService : IAuthService
{
  private readonly UserManager<AppUser> _userManager;
  private readonly IEmailService _email;

  public AuthService(UserManager<AppUser> userManager, IEmailService email)
  {
    _userManager = userManager;
    _email = email;
  }



  public async Task GenerateAndSendOtpAsync(AppUser user)
  {
    var code = RandomNumberGenerator.GetInt32(100000, 999999).ToString();

    user.VerficationCode = code;
    user.VerficationCodeExpiry = DateTime.UtcNow.AddMinutes(15);

    await _userManager.UpdateAsync(user);

    await _email.SendEmailAsync(
        user.Email!,
        "Verify your Ticketa account",
        EmailTemplates.VerificationCode(code)
    );
  }

  public async Task<bool> VerifyOtpAsync(AppUser user, string code)
  {
    if (user.VerficationCode != code)
      return false;

    if (user.VerficationCodeExpiry < DateTime.UtcNow)
      return false;

    user.EmailConfirmed = true;
    user.VerficationCode = null;
    user.VerficationCodeExpiry = null;

    await _userManager.UpdateAsync(user);

    return true;
  }

  public async Task<bool> ForgotPasswordAsync(string email, string resetLink)
  {
    var user = await _userManager.FindByEmailAsync(email);

    if (user is null || !user.EmailConfirmed)
      return true;

    var subject = "Reset your Ticketa password";
    var body = EmailTemplates.ForgotPassword(user.UserName ?? "there", resetLink);

    await _email.SendEmailAsync(user.Email!, subject, body);
    return true;
  }

  public async Task<(bool Success, IEnumerable<string> Errors)> ResetPasswordAsync(string email, string token, string newPassword)
  {
    var user = await _userManager.FindByEmailAsync(email);
    if (user == null)
      return (false, new[] { "Invalid request." });

    var result = await _userManager.ResetPasswordAsync(user, token, newPassword);

    return result.Succeeded
        ? (true, Enumerable.Empty<string>())
        : (false, result.Errors.Select(e => e.Description));
  }
}