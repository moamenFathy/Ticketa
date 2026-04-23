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
}