using Microsoft.AspNetCore.Identity;

namespace Ticketa.Core.Entities
{
  public class AppRole : IdentityRole
  {
    public bool IsAdminRole { get; set; }
  }
}
