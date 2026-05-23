using Microsoft.AspNetCore.Identity;
using System.Security.Cryptography;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Service;

public class AuthService(UserManager<AppUser> userManager, IEmailService emailService) : IAuthService
{
  public async Task GenerateAndSendOtpAsync(AppUser user)
  {
    var code = RandomNumberGenerator.GetInt32(100000, 999999).ToString();

    user.VerificationCode = code;
    user.VerificationCodeExpiry = DateTime.UtcNow.AddMinutes(15);

    await userManager.UpdateAsync(user);

    await emailService.SendEmailAsync(
        user.Email!,
        "Verify your Ticketa account",
        EmailTemplates.VerificationCode(code)
    );
  }

  public async Task<bool> VerifyOtpAsync(AppUser user, string code)
  {
    if (user.VerificationCode != code)
      return false;

    if (user.VerificationCodeExpiry < DateTime.UtcNow)
      return false;

    user.EmailConfirmed = true;
    user.VerificationCode = null;
    user.VerificationCodeExpiry = null;

    await userManager.UpdateAsync(user);

    return true;
  }

  public async Task<bool> ForgotPasswordAsync(string email, string resetLink)
  {
    var user = await userManager.FindByEmailAsync(email);

    if (user is null || !user.EmailConfirmed)
      return true;

    var subject = "Reset your Ticketa password";
    var body = EmailTemplates.ForgotPassword(user.UserName ?? "there", resetLink);

    await emailService.SendEmailAsync(user.Email!, subject, body);
    return true;
  }

  public async Task<(bool Success, IEnumerable<string> Errors)> ResetPasswordAsync(string email, string token, string newPassword)
  {
    var user = await userManager.FindByEmailAsync(email);
    if (user == null)
      return (false, new[] { "Invalid request." });

    var result = await userManager.ResetPasswordAsync(user, token, newPassword);

    return result.Succeeded
        ? (true, Enumerable.Empty<string>())
        : (false, result.Errors.Select(e => e.Description));
  }
}