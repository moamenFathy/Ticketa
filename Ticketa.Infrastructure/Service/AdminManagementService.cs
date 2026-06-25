using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Service
{
  public class AdminManagementService(
      UserManager<AppUser> userManager,
      ApplicationDbContext context) : IAdminManagementService
  {
    private readonly UserManager<AppUser> _userManager = userManager;
    private readonly ApplicationDbContext _context = context;
    public async Task<(bool Success, IEnumerable<string> Errors)> CreateUserAsync(AdminUserUpsertDto dto)
    {
      var errors = new List<string>();

      if (string.IsNullOrEmpty(dto.Password))
      {
        errors.Add("Password is required for new users.");
        return (false, errors);
      }

      var user = new AppUser
      {
        UserName = dto.Email,
        Email = dto.Email,
        FirstName = dto.FirstName,
        LastName = dto.LastName,
        EmailConfirmed = true
      };

      var createResult = await _userManager.CreateAsync(user, dto.Password);
      if (!createResult.Succeeded)
      {
        errors.AddRange(createResult.Errors.Select(e => e.Description));
        return (false, errors);
      }

      if (!string.IsNullOrEmpty(dto.Role))
        await _userManager.AddToRoleAsync(user, dto.Role);

      return (true, errors);
    }

    public async Task<(bool Success, IEnumerable<string> Errors)> UpdateUserAsync(AdminUserUpsertDto dto)
    {
      var errors = new List<string>();

      var user = await _userManager.FindByIdAsync(dto.Id!);
      if (user is null)
      {
        errors.Add("User not found.");
        return (false, errors);
      }

      user.FirstName = dto.FirstName;
      user.LastName = dto.LastName;
      user.Email = dto.Email;
      user.UserName = dto.Email;

      var updateResult = await _userManager.UpdateAsync(user);
      if (!updateResult.Succeeded)
      {
        errors.AddRange(updateResult.Errors.Select(e => e.Description));
        return (false, errors);
      }

      var currentRoles = await _userManager.GetRolesAsync(user);
      await _userManager.RemoveFromRolesAsync(user, currentRoles);
      if (!string.IsNullOrEmpty(dto.Role))
        await _userManager.AddToRoleAsync(user, dto.Role);

      if (!string.IsNullOrEmpty(dto.Password))
      {
        var token = await _userManager.GeneratePasswordResetTokenAsync(user);
        await _userManager.ResetPasswordAsync(user, token, dto.Password);
      }

      return (true, errors);
    }

    public async Task<List<AdminUserListItemDto>> GetAdminUsersAsync()
    {
      var adminUsers = await _context.Users
          .Join(
              _context.UserRoles,
              user => user.Id,
              userRole => userRole.UserId,
              (user, userRole) => new { user, userRole }
          )
          .Join(
              _context.Roles.Where(r => r.IsAdminRole),
              combined => combined.userRole.RoleId,
              role => role.Id,
              (combined, role) => new AdminUserListItemDto
              {
                Id = combined.user.Id,
                FullName = combined.user.FirstName + " " + combined.user.LastName,
                Email = combined.user.Email!,
                Role = role.Name!,
              }
          )
          .OrderBy(u => u.FullName)
          .ToListAsync();

      return adminUsers;
    }
  }
}
