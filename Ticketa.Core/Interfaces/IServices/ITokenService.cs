using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface ITokenService
  {
    string GenerateAccessToken(AppUser user, IList<string> roles);
    string GenerateRefreshToken();
  }
}
