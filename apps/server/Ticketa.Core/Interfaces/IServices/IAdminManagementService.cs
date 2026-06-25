using Ticketa.Core.DTOs;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IAdminManagementService
  {
    Task<(bool Success, IEnumerable<string> Errors)> CreateUserAsync(AdminUserUpsertDto dto);
    Task<(bool Success, IEnumerable<string> Errors)> UpdateUserAsync(AdminUserUpsertDto dto);
    Task<List<AdminUserListItemDto>> GetAdminUsersAsync();
  }
}
