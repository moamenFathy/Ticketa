using Microsoft.AspNetCore.Authorization;

namespace Ticketa.Infrastructure.Authorization;

public class RequirePermissionAttribute(string permission) : AuthorizeAttribute(permission)
{
}
