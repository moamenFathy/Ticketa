namespace Ticketa.Core.DTOs.Roles
{
  public class RoleUpsertDto
  {
    public string? Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public bool IsAdminRole { get; set; }
    public List<string> SelectedPermissions { get; set; } = [];
  }
}
