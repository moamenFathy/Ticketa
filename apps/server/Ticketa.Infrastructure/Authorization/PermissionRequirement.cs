using Microsoft.AspNetCore.Authorization;

namespace Ticketa.Infrastructure.Authorization;

public class PermissionRequirement(string permission) : IAuthorizationRequirement
{
    public string Permission { get; } = permission;
}
