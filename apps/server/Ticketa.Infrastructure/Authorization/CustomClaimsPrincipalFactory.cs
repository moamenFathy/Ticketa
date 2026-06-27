using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using System.Security.Claims;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Authorization;

#pragma warning disable CS9107 // Parameter is captured into the state of the enclosing type and its value is also passed to the base constructor
public class CustomClaimsPrincipalFactory(
    UserManager<AppUser> userManager,
    RoleManager<AppRole> roleManager,
    IOptions<IdentityOptions> optionsAccessor)
    : UserClaimsPrincipalFactory<AppUser, AppRole>(userManager, roleManager, optionsAccessor)
#pragma warning restore CS9107
{
    public override async Task<ClaimsPrincipal> CreateAsync(AppUser user)
    {
        var principal = await base.CreateAsync(user);
        var roles = await UserManager.GetRolesAsync(user);

        var permissionClaims = new List<Claim>();
        foreach (var roleName in roles)
        {
            var role = await roleManager.FindByNameAsync(roleName);
            if (role is null) continue;
            var claims = await roleManager.GetClaimsAsync(role);
            permissionClaims.AddRange(
                claims.Where(c => c.Type == "permission")
                      .Select(c => new Claim("permission", c.Value)));
        }

        if (permissionClaims.Count > 0)
        {
            var identity = (ClaimsIdentity)principal.Identity!;
            identity.AddClaims(permissionClaims.DistinctBy(c => c.Value));
        }

        return principal;
    }
}
