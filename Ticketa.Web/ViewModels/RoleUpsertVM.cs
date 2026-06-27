namespace Ticketa.Web.ViewModels
{
  public class RoleUpsertVM
  {
    public string? Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public bool IsAdminRole { get; set; }
    public List<string> SelectedPermissions { get; set; } = [];
    public Dictionary<string, List<string>> AllPermissionsGrouped { get; set; } = [];
  }
}
