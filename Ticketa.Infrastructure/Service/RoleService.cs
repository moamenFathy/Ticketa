using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Ticketa.Core.DTOs.Roles;
using Ticketa.Core.Entities;
using Ticketa.Core.Helpers;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Service
{
  public class RoleService(
      RoleManager<AppRole> roleManager,
      ApplicationDbContext context) : IRoleService
  {
    private readonly RoleManager<AppRole> _roleManager = roleManager;
    private readonly ApplicationDbContext _context = context;

    public async Task<List<RoleListItemDto>> GetAllAsync()
    {
      var roles = await _roleManager.Roles.ToListAsync();
      var result = new List<RoleListItemDto>();

      foreach (var role in roles)
      {
        var claims = await _roleManager.GetClaimsAsync(role);
        var userCount = await _context.UserRoles.CountAsync(ur => ur.RoleId == role.Id);

        result.Add(new RoleListItemDto
        {
          Id = role.Id,
          Name = role.Name ?? "",
          IsAdminRole = role.IsAdminRole,
          PermissionCount = claims.Count(c => c.Type == "permission"),
          UserCount = userCount
        });
      }

      return result;
    }

    public async Task<RoleUpsertDto?> GetByIdAsync(string id)
    {
      var role = await _roleManager.FindByIdAsync(id);
      if (role is null) return null;

      var claims = await _roleManager.GetClaimsAsync(role);

      return new RoleUpsertDto
      {
        Id = role.Id,
        Name = role.Name ?? "",
        IsAdminRole = role.IsAdminRole,
        SelectedPermissions = claims
            .Where(c => c.Type == "permission")
            .Select(c => c.Value)
            .ToList()
      };
    }

    public async Task<(bool Success, IEnumerable<string> Errors)> CreateAsync(RoleUpsertDto dto)
    {
      var errors = new List<string>();

      if (await _roleManager.RoleExistsAsync(dto.Name))
      {
        errors.Add("Role name already exists.");
        return (false, errors);
      }

      var role = new AppRole(dto.Name)
      {
        IsAdminRole = dto.IsAdminRole
      };

      var result = await _roleManager.CreateAsync(role);
      if (!result.Succeeded)
      {
        errors.AddRange(result.Errors.Select(e => e.Description));
        return (false, errors);
      }

      foreach (var permission in dto.SelectedPermissions)
      {
        await _roleManager.AddClaimAsync(role, new Claim("permission", permission));
      }

      return (true, errors);
    }

    public async Task<(bool Success, IEnumerable<string> Errors)> UpdateAsync(RoleUpsertDto dto)
    {
      var errors = new List<string>();

      var role = await _roleManager.FindByIdAsync(dto.Id!);
      if (role is null)
      {
        errors.Add("Role not found.");
        return (false, errors);
      }

      if (role.Name != dto.Name && await _roleManager.RoleExistsAsync(dto.Name))
      {
        errors.Add("Role name already exists.");
        return (false, errors);
      }

      role.Name = dto.Name;
      role.IsAdminRole = dto.IsAdminRole;

      var updateResult = await _roleManager.UpdateAsync(role);
      if (!updateResult.Succeeded)
      {
        errors.AddRange(updateResult.Errors.Select(e => e.Description));
        return (false, errors);
      }

      var existingClaims = await _roleManager.GetClaimsAsync(role);
      var permissionClaims = existingClaims.Where(c => c.Type == "permission").ToList();

      foreach (var claim in permissionClaims)
      {
        await _roleManager.RemoveClaimAsync(role, claim);
      }

      foreach (var permission in dto.SelectedPermissions)
      {
        await _roleManager.AddClaimAsync(role, new Claim("permission", permission));
      }

      return (true, errors);
    }

    public async Task<(bool Success, string? Error)> DeleteAsync(string id)
    {
      var role = await _roleManager.FindByIdAsync(id);
      if (role is null)
        return (false, "Role not found.");

      var userCount = await _context.UserRoles.CountAsync(ur => ur.RoleId == role.Id);
      if (userCount > 0)
        return (false, $"Cannot delete role '{role.Name}' — {userCount} user(s) are assigned to it.");

      var result = await _roleManager.DeleteAsync(role);
      if (!result.Succeeded)
        return (false, result.Errors.First().Description);

      return (true, null);
    }

    public List<string> GetAllPermissions() => Permissions.GetAll().ToList();
  }
}