using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using Ticketa.Web.ViewModels;

namespace Ticketa.Web.Areas.Customer.Controllers
{
  [Area("Customer")]
  public class HomeController : Controller
  {
    public IActionResult Index()
    {
      return View();
    }

    public IActionResult Privacy()
    {
      return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
      return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
  }
}
