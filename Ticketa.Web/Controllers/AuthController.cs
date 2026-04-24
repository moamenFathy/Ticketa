using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Web.ViewModels;

[Route("[controller]/[action]")]
public class AuthController : Controller
{
  private readonly UserManager<AppUser> _userManager;
  private readonly SignInManager<AppUser> _signInManger;
  private readonly IAuthService _authService;

  public AuthController(
      UserManager<AppUser> userManager,
      SignInManager<AppUser> signInManger,
      IEmailService email,
      IAuthService authService)
  {
    _userManager = userManager;
    _signInManger = signInManger;
    _authService = authService;
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
      return View(model);

    var user = new AppUser
    {
      UserName = model.Email,
      Email = model.Email,
      DateOfBirth = model.DateOfBirth,
      EmailConfirmed = false
    };

    var result = await _userManager.CreateAsync(user, model.Password);

    if (result.Succeeded)
    {
      await _userManager.AddToRoleAsync(user, "User");

      await _authService.GenerateAndSendOtpAsync(user);

      return RedirectToAction("VerifyEmail", new { email = user.Email });
    }

    foreach (var error in result.Errors)
    {
      if (!error.Code.Contains("UserName"))
        ModelState.AddModelError("", error.Description);
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

    var user = await _userManager.FindByEmailAsync(model.Email);

    if (user != null && !user.EmailConfirmed &&
        await _userManager.CheckPasswordAsync(user, model.Password))
    {
      TempData["StatusMessage"] = "The verification code sent successfully, please check you email.";
      return RedirectToAction("VerifyEmail", new { email = model.Email });
    }

    var result = await _signInManger.PasswordSignInAsync(
        model.Email, model.Password, model.RememberMe, false);

    if (result.Succeeded)
    {
      if (user != null && !string.IsNullOrEmpty(user.Theme))
      {
        Response.Cookies.Append("theme", user.Theme,
            new CookieOptions { MaxAge = TimeSpan.FromDays(365), Path = "/" });
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
    return RedirectToAction("Index", "Home");
  }

  public IActionResult VerifyEmail(string email)
  {
    return View(new VerifyEmailVM { Email = email });
  }

  [HttpPost]
  [ValidateAntiForgeryToken]
  public async Task<IActionResult> VerifyEmail(VerifyEmailVM model)
  {
    if (!ModelState.IsValid)
      return View(model);

    var user = await _userManager.FindByEmailAsync(model.Email);
    if (user == null)
      return NotFound();

    var isValid = await _authService.VerifyOtpAsync(user, model.Code);

    if (!isValid)
    {
      ModelState.AddModelError("", "Invalid or expired code");
      return View(model);
    }

    await _signInManger.SignInAsync(user, true);

    TempData["StatusMessage"] = "The verification code sent successfully, please check you email.";
    return RedirectToAction("Index", "Home", new { area = "Customer" });
  }

  public async Task<IActionResult> ResendVerificationCode(string email)
  {
    var user = await _userManager.FindByEmailAsync(email);
    if (user == null)
      return NotFound();

    await _authService.GenerateAndSendOtpAsync(user);

    TempData["StatusMessage"] = "New code sent.";
    return RedirectToAction("VerifyEmail", new { email = user.Email });
  }
}