using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.Interfaces;

namespace Ticketa.Web.Areas.Admin.Controllers
{
  [Area("Admin")]
  public class HallController : Controller
  {
    private readonly IUnitOfWork _uow;

    public HallController(IUnitOfWork uow)
    {
      _uow = uow;
    }

    public async Task<ActionResult> Index()
    {
      var halls = await _uow.Halls.GetAllAsync();
      return View(halls);
    }
  }
}
