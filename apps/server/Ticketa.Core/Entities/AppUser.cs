using Microsoft.AspNetCore.Identity;

namespace Ticketa.Core.Entities
{
  public class AppUser : IdentityUser
  {
    public DateOnly DateOfBirth { get; set; }
    public string Theme { get; set; } = "light";
    public string? VerficationCode { get; set; }
    public DateTime? VerficationCodeExpiry { get; set; }
  }
}
