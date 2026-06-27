using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs.Roles;
using Ticketa.Core.Helpers;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Web.ViewModels;

namespace Ticketa.Web.Controllers
{
  [Authorize]
  public class RoleController(IRoleService roleService) : Controller
  {
    private readonly IRoleService _roleService = roleService;

    public IActionResult Index() => View();

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
      var result = await _roleService.GetAllAsync();
      return Json(new { data = result });
    }

    [HttpGet]
    public IActionResult Upsert(string? id)
    {
      var groupedPermissions = GetGroupedPermissions();

      if (string.IsNullOrEmpty(id))
      {
        return PartialView("_RoleFormModal", new RoleUpsertVM
        {
          AllPermissionsGrouped = groupedPermissions
        });
      }

      return PartialView("_RoleFormModal", new RoleUpsertVM
      {
        Id = "",
        AllPermissionsGrouped = groupedPermissions
      });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Upsert(RoleUpsertVM vm)
    {
      if (!ModelState.IsValid)
      {
        vm.AllPermissionsGrouped = GetGroupedPermissions();
        return PartialView("_RoleFormModal", vm);
      }

      var dto = new RoleUpsertDto
      {
        Id = vm.Id,
        Name = vm.Name,
        IsAdminRole = vm.IsAdminRole,
        SelectedPermissions = vm.SelectedPermissions ?? []
      };

      var (success, errors) = string.IsNullOrEmpty(vm.Id)
          ? await _roleService.CreateAsync(dto)
          : await _roleService.UpdateAsync(dto);

      if (!success)
      {
        foreach (var err in errors)
          ModelState.AddModelError("", err);
        vm.AllPermissionsGrouped = GetGroupedPermissions();
        return PartialView("_RoleFormModal", vm);
      }

      TempData["Success"] = string.IsNullOrEmpty(vm.Id)
          ? "Role created successfully"
          : "Role updated successfully";
      return Json(new { success = true });
    }

    [HttpGet]
    public async Task<IActionResult> LoadForEdit(string id)
    {
      var role = await _roleService.GetByIdAsync(id);
      if (role is null) return NotFound();

      return PartialView("_RoleFormModal", new RoleUpsertVM
      {
        Id = role.Id,
        Name = role.Name,
        IsAdminRole = role.IsAdminRole,
        SelectedPermissions = role.SelectedPermissions,
        AllPermissionsGrouped = GetGroupedPermissions()
      });
    }

    [HttpGet]
    public async Task<IActionResult> DeleteConfirmation(string id)
    {
      var roles = await _roleService.GetAllAsync();
      var role = roles.FirstOrDefault(r => r.Id == id);
      if (role is null) return NotFound();
      return PartialView("_DeleteRoleModal", role);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(string id)
    {
      var (success, error) = await _roleService.DeleteAsync(id);
      if (!success)
        return Json(new { success = false, message = error });

      TempData["Success"] = "Role deleted successfully";
      return Json(new { success = true });
    }

    private static Dictionary<string, List<string>> GetGroupedPermissions()
    {
      var modules = new Dictionary<string, List<string>>();
      var type = typeof(Permissions);

      foreach (var nested in type.GetNestedTypes())
      {
        var moduleName = nested.Name;
        var permissions = nested.GetFields(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static)
            .Select(f => (string)f.GetValue(null)!)
            .ToList();

        if (permissions.Count > 0)
          modules[moduleName] = permissions;
      }

      return modules;
    }
  }
}
