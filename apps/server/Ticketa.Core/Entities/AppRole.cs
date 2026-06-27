using Microsoft.AspNetCore.Identity;

namespace Ticketa.Core.Entities
{
  public class AppRole : IdentityRole
  {
    public AppRole() { }

    public AppRole(string roleName) : base(roleName) { }

    public bool IsAdminRole { get; set; }
  }
}
