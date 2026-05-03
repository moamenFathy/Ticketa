using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ticketa.Web.Controllers
{
  [Authorize]
  public class DashboardController : Controller
  {
    public IActionResult Index()
    {
      return View();
    }
  }
}
