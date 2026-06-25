using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Web.ViewModels;

namespace Ticketa.Web.Controllers
{
  public class AdminUserManagementController(
      UserManager<AppUser> userManager,
      RoleManager<AppRole> roleManager,
      IAdminManagementService adminManagementService) : Controller
  {
    public IActionResult Index() => View();

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
      var result = await adminManagementService.GetAdminUsersAsync();
      return Json(new { data = result });
    }

    [HttpGet]
    public async Task<IActionResult> Upsert(string? id)
    {
      var roles = await roleManager.Roles.Select(r => r.Name!).ToListAsync();

      if (string.IsNullOrEmpty(id))
      {
        return PartialView("_UserFormModal", new AdminUserUpsertVM
        {
          AvailableRoles = roles
        });
      }

      var user = await userManager.FindByIdAsync(id);
      if (user is null) return NotFound();

      var userRoles = await userManager.GetRolesAsync(user);

      return PartialView("_UserFormModal", new AdminUserUpsertVM
      {
        Id = user.Id,
        FirstName = user.FirstName,
        LastName = user.LastName,
        Email = user.Email ?? "",
        Password = "",
        ConfirmPassword = "",
        Role = userRoles.FirstOrDefault() ?? "",
        AvailableRoles = roles
      });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Upsert(AdminUserUpsertVM vm)
    {
      if (!ModelState.IsValid)
      {
        vm.AvailableRoles = await roleManager.Roles.Select(r => r.Name!).ToListAsync();
        return PartialView("_UserFormModal", vm);
      }

      var dto = new AdminUserUpsertDto
      {
        Id = vm.Id,
        FirstName = vm.FirstName,
        LastName = vm.LastName,
        Email = vm.Email,
        Password = vm.Password,
        Role = vm.Role
      };

      var (success, errors) = string.IsNullOrEmpty(vm.Id)
          ? await adminManagementService.CreateUserAsync(dto)
          : await adminManagementService.UpdateUserAsync(dto);

      if (!success)
      {
        foreach (var err in errors)
          ModelState.AddModelError("", err);
        vm.AvailableRoles = await roleManager.Roles.Select(r => r.Name!).ToListAsync();
        return PartialView("_UserFormModal", vm);
      }

      TempData["Success"] = string.IsNullOrEmpty(vm.Id)
          ? "User created successfully"
          : "User updated successfully";
      return Json(new { success = true });
    }

    [HttpGet]
    public async Task<IActionResult> DeleteConfirmation(string id)
    {
      var user = await userManager.FindByIdAsync(id);
      if (user is null) return NotFound();
      return PartialView("_DeleteUserModal", user);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(string id)
    {
      var user = await userManager.FindByIdAsync(id);
      if (user is null)
      {
        return Json(new { success = false, message = "User not found." });
      }

      var result = await userManager.DeleteAsync(user);
      if (!result.Succeeded)
      {
        return Json(new { success = false, message = "Failed to delete user." });
      }

      TempData["success"] = "User deleted successfully";
      return Json(new { success = true });
    }
  }
}
