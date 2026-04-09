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
    public async Task<IActionResult> Upsert(int? id)
    {
      var hall = id.HasValue ? await _uow.Halls.GetAsync(h => h.Id == id.Value) : new Hall();

      if (!id.HasValue)
      {
        return PartialView("_CreateHallModal", hall);
      }
      else
      {
        return PartialView("_EditHallModal", hall);
      }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Upsert(Hall model)
    {
      if (!ModelState.IsValid && model.Id == 0)
      {
        return PartialView("_EditHallModal", model);
      }

      if (model.Id == 0)
      {
        await _uow.Halls.CreateAsync(model);
        await _uow.SaveAsync();
        return Json(new { success = true, data = new { id = model.Id, name = model.Name, totalSeats = model.TotalSeats } });
      }
      else
      {
        _uow.Halls.Update(model);
        await _uow.SaveAsync();
        return Json(new { success = true, data = new { id = model.Id, name = model.Name, totalSeats = model.TotalSeats } });
      }
    }

  }
}
