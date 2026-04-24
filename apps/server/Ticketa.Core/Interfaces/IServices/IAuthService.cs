using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IAuthService
  {
    Task GenerateAndSendOtpAsync(AppUser user);
    Task<bool> VerifyOtpAsync(AppUser user, string code);

    Task<bool> ForgotPasswordAsync(string email, string resetLink);
    Task<(bool Success, IEnumerable<string> Errors)> ResetPasswordAsync(
      string email, string token, string newPassword);
  }
}
