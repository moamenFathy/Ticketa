using Microsoft.AspNetCore.Mvc;
using Ticketa.Infrastructure.Authorization;
using static Ticketa.Core.Helpers.Permissions;

namespace Ticketa.Web.Controllers
{
  public class DashboardController : Controller
  {
    [RequirePermission(Dashboard.View)]
    public IActionResult Index()
    {
      return View();
    }
  }
}
