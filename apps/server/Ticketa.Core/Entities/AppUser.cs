using Microsoft.AspNetCore.Identity;

namespace Ticketa.Core.Entities
{
  public class AppUser : IdentityUser
  {
    public DateOnly DateOfBirth { get; set; }
    public string Theme { get; set; } = "light";
    public string? VerificationCode { get; set; }
    public DateTime? VerificationCodeExpiry { get; set; }
    public string? RefreshToken { get; set; }
    public DateTime? RefreshTokenExpiry { get; set; }
  }
}
