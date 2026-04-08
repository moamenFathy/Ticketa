using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.Entities;
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

    [HttpGet]
    public async Task<IActionResult> Edit(int id)
    {
      var hall = await _uow.Halls.GetAsync(h => h.Id == id);

      return PartialView("_EditHallModal", hall);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(Hall model)
    {
      if (!ModelState.IsValid)
      {
        return PartialView("_EditHallModal", model);
      }

      _uow.Halls.Update(model);
      await _uow.SaveAsync();
      return Json(new { success = true, data = new { id = model.Id, name = model.Name, totalSeats = model.TotalSeats } });
    }
  }
}
