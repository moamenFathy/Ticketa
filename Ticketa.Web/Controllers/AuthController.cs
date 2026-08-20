using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.Entities;
using Ticketa.Web.ViewModels;

[Route("[controller]/[action]")]
public class AuthController : Controller
{
  private readonly UserManager<AppUser> _userManager;
  private readonly SignInManager<AppUser> _signInManger;

  public AuthController(
      UserManager<AppUser> userManager,
      SignInManager<AppUser> signInManger)
  {
    _userManager = userManager;
    _signInManger = signInManger;
  }

  [AllowAnonymous]
  public IActionResult AccessDenied()
  {
    return View();
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

    var user = await _userManager.FindByEmailAsync(model.Email);

    var result = await _signInManger.PasswordSignInAsync(
        model.Email, model.Password, model.RememberMe, false);

    if (result.Succeeded)
    {
      if (user != null && !string.IsNullOrEmpty(user.Theme))
      {
        Response.Cookies.Append("theme", user.Theme,
            new CookieOptions { MaxAge = TimeSpan.FromDays(365), Path = "/", Secure = true, HttpOnly = false, SameSite = SameSiteMode.Lax });
      }

      if (Url.IsLocalUrl(returnUrl))
        return LocalRedirect(returnUrl);

      return LocalRedirect("/");
    }

    ModelState.AddModelError("", "Invalid login attempt.");
    return View(model);
  }

  public async Task<IActionResult> Logout()
  {
    await _signInManger.SignOutAsync();
    Response.Cookies.Delete("theme");
    return RedirectToAction(nameof(Login));
  }
}
