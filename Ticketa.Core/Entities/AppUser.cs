using Microsoft.AspNetCore.Identity;

namespace Ticketa.Core.Entities
{
  public class AppUser : IdentityUser
  {
    public DateOnly DateOfBirth { get; set; }
  }
}
