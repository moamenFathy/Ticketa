using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Settings;

namespace Ticketa.Infrastructure.Service
{
  public class TokenService(IOptions<JwtSettings> jwt) : ITokenService
  {
    private readonly JwtSettings _jwt = jwt.Value;

    public string GenerateAccessToken(AppUser user, IList<string> roles)
    {
      var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwt.SecretKey));
      var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

      var claims = new List<Claim>
      {
        new Claim(ClaimTypes.NameIdentifier, user.Id),
        new Claim(ClaimTypes.Name, user.UserName!),
        new Claim(ClaimTypes.Email, user.Email!)
      };

      claims.AddRange(roles.Select(role => new Claim(ClaimTypes.Role, role)));

      var token = new JwtSecurityToken(
        issuer: _jwt.Issuer,
        audience: _jwt.Audience,
        claims: claims,
        expires: DateTime.UtcNow.AddMinutes(_jwt.ExpiryMinutes),
        signingCredentials: creds
      );

      return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public string GenerateRefreshToken()
    {
      var bytes = RandomNumberGenerator.GetBytes(64);
      return Convert.ToBase64String(bytes);
    }
  }
}
