namespace Ticketa.Core.DTOs.Roles
{
  public class RoleListItemDto
  {
    public string Id { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public bool IsAdminRole { get; set; }
    public int PermissionCount { get; set; }
    public int UserCount { get; set; }
  }
}
