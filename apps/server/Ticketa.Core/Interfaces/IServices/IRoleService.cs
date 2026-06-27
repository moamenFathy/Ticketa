using Ticketa.Core.DTOs.Roles;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IRoleService
  {
    Task<List<RoleListItemDto>> GetAllAsync();
    Task<RoleUpsertDto?> GetByIdAsync(string id);
    Task<(bool Success, IEnumerable<string> Errors)> CreateAsync(RoleUpsertDto dto);
    Task<(bool Success, IEnumerable<string> Errors)> UpdateAsync(RoleUpsertDto dto);
    Task<(bool Success, string? Error)> DeleteAsync(string id);
    List<string> GetAllPermissions();
  }
}
