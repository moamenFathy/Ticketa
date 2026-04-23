using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IAuthService
  {
    Task GenerateAndSendOtpAsync(AppUser user);
    Task<bool> VerifyOtpAsync(AppUser user, string code);
  }
}
