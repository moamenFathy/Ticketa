using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces;
using Ticketa.Core.DTOs;
using Ticketa.Web.ViewModels;

namespace Ticketa.Web.Controllers
{
  [Route("[controller]/[action]")]
  public class AuthController : Controller
  {
    private readonly UserManager<AppUser> _userManager;
    private readonly SignInManager<AppUser> _signInManger;

    public AuthController(UserManager<AppUser> userManager, IUnitOfWork uow, SignInManager<AppUser> signInManger)
    {
      _userManager = userManager;
      _signInManger = signInManger;
    }

    public IActionResult Register()
    {
      return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Register(ReigsterVM model)
    {
      if (!ModelState.IsValid)
      {
        return View(model);
      }

      var user = new AppUser
      {
        UserName = model.Email,
        Email = model.Email,
        DateOfBirth = model.DateOfBirth
      };

      var result = await _userManager.CreateAsync(user, model.Password);

      if (result.Succeeded)
      {
        await _userManager.AddToRoleAsync(user, "User");
        return RedirectToAction(nameof(Login));
      }

      foreach (var error in result.Errors)
      {
        if (!error.Code.Contains("UserName"))
        {
          ModelState.AddModelError("", error.Description);
        }
      }

      return View(model);
    }

    public IActionResult Login()
    {
      return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginVM model, string? returnUrl = null)
    {
      if (!ModelState.IsValid)
        return View(model);

      var result = await _signInManger.PasswordSignInAsync(model.Email, model.Password, model.RememberMe, lockoutOnFailure: false);

      if (result.Succeeded)
      {
        var user = await _userManager.FindByEmailAsync(model.Email);
        if (user != null && !string.IsNullOrEmpty(user.Theme))
        {
            Response.Cookies.Append("theme", user.Theme, new CookieOptions { MaxAge = TimeSpan.FromDays(365), Path = "/" });
        }

        if (Url.IsLocalUrl(returnUrl))
            return LocalRedirect(returnUrl);

        return LocalRedirect("/");
      }

      ModelState.AddModelError(string.Empty, "Invalid login attempt.");
      return View(model);
    }

    public async Task<IActionResult> Logout()
    {
      await _signInManger.SignOutAsync();
      Response.Cookies.Delete("theme");
      return RedirectToAction("Index", "Home");
    }

    [HttpPost]
    [IgnoreAntiforgeryToken] // Allow AJAX calls simply without token checking for a minor theme setting, or you can implement CSRF headers
    public async Task<IActionResult> UpdateTheme([FromBody] UpdateThemeDto dto)
    {
        if (User?.Identity?.IsAuthenticated == true)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user != null && dto.Theme != null)
            {
                user.Theme = dto.Theme;
                await _userManager.UpdateAsync(user);
            }
        }
        return Ok();
    }
  }
}