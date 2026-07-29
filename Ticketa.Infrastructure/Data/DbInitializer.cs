using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System.Security.Claims;
using Ticketa.Core.Entities;
using Ticketa.Core.Helpers;

namespace Ticketa.Infrastructure.Data
{
    public static class DbInitializer
    {
        public static async Task SeedAdminPermissionsAsync(IServiceProvider serviceProvider)
        {
            using var scope = serviceProvider.CreateScope();
            var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<AppRole>>();

            var adminRole = await roleManager.FindByNameAsync("Admin");
            if (adminRole is null) return;

            var existingClaims = await roleManager.GetClaimsAsync(adminRole);
            var existingPermissions = existingClaims
                .Where(c => c.Type == "permission")
                .Select(c => c.Value)
                .ToHashSet();

            foreach (var permission in Permissions.GetAll())
            {
                if (!existingPermissions.Contains(permission))
                {
                    await roleManager.AddClaimAsync(adminRole, new Claim("permission", permission));
                }
            }
        }
    }
}
