using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Helpers;
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

    public ActionResult Index()
    {
      return View();
    }

    // ─── DataTable feed ───────────────────────────────────────────────────────

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
      var halls = await _uow.Halls.GetAllAsync(filter: null, includes: "Showtimes");
      var result = halls.Select((h, index) => new
      {
        rowNumber = index + 1,
        id = h.Id,
        name = h.Name,
        hallType = h.Type.ToString(),
        totalRows = h.TotalRows,
        seatsPerRow = h.SeatsPerRow,
        totalSeats = h.TotalSeats,
        hasShowtimes = h.Showtimes.Any()
      }).ToList();
      return Json(new { data = result });
    }

    // ─── Create ───────────────────────────────────────────────────────────────

    [HttpGet]
    public async Task<IActionResult> Upsert(int? id)
    {
      if (!id.HasValue)
        return PartialView("_CreateHallModal", new HallUpsertDto());

      var hall = await _uow.Halls.GetAsync(h => h.Id == id.Value);

      if (hall is null)
        return NotFound();

      // Edit mode — map to a DTO that carries the read-only template info
      var dto = new HallUpsertDto
      {
        Id = hall.Id,
        Name = hall.Name,
        Type = hall.Type
      };
      return PartialView("_EditHallModal", dto);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Upsert(HallUpsertDto dto, int? id)
    {
      int? effectiveId = id ?? (dto.Id > 0 ? dto.Id : (int?)null);

      if (!ModelState.IsValid)
      {
        if (effectiveId.HasValue)
        {
          var existingHall = await _uow.Halls.GetAsync(h => h.Id == effectiveId.Value);
          if (existingHall != null)
          {
            dto.Id = existingHall.Id;
            dto.Type = existingHall.Type;
            return PartialView("_EditHallModal", dto);
          }
          return NotFound();
        }
        return PartialView("_CreateHallModal", dto);
      }

      // ── Create ──
      if (!effectiveId.HasValue)
      {
        if (await IsHallExist(dto.Name, dto.Type))
        {
          ModelState.AddModelError(nameof(HallUpsertDto.Name), $"A {dto.Type} hall named '{dto.Name}' already exists.");
          return PartialView("_CreateHallModal", dto);
        }

        var template = HallTypeHelper.GetTemplate(dto.Type);

        var hall = new Hall
        {
          Name = dto.Name,
          Type = dto.Type,
          TotalRows = template.Rows,
          SeatsPerRow = template.SeatsPerRow
        };

        await _uow.Halls.CreateAsync(hall);
        await _uow.SaveAsync();

        TempData["Success"] = "Hall created successfully";
        return Json(new
        {
          success = true,
          data = new
          {
            id = hall.Id,
            name = hall.Name,
            hallType = hall.Type.ToString(),
            totalRows = hall.TotalRows,
            seatsPerRow = hall.SeatsPerRow,
            totalSeats = hall.TotalSeats
          }
        });
      }

      // ── Edit (name-only) ──
      var existing = await _uow.Halls.GetAsync(h => h.Id == effectiveId.Value);
      if (existing is null)
        return NotFound();

      if (await IsHallExist(dto.Name, type: existing.Type, excludedId: effectiveId.Value))
      {
        ModelState.AddModelError(nameof(HallUpsertDto.Name), $"A {existing.Type} hall named '{dto.Name}' already exists.");
        dto.Id = existing.Id;
        dto.Type = existing.Type;
        return PartialView("_EditHallModal", dto);
      }

      existing.Name = dto.Name;
      _uow.Halls.Update(existing);
      await _uow.SaveAsync();

      TempData["Success"] = "Hall updated successfully";
      return Json(new { success = true });
    }

    // ─── Delete ───────────────────────────────────────────────────────────────

    [HttpGet]
    public async Task<IActionResult> DeleteConfirmation(int id)
    {
      var hall = await _uow.Halls.GetAsync(h => h.Id == id);

      if (hall is null)
        return NotFound();

      return PartialView("_DeleteHallModal", hall);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
      var hall = await _uow.Halls.GetAsync(h => h.Id == id);
      if (hall is null)
      {
        TempData["Error"] = "The hall was not found";
        return Json(new { success = false, message = "Hall not found." });
      }

      if (await _uow.Showtimes.AnyAsync(s => s.HallId == id))
      {
        return Json(new { success = false, message = "Cannot delete hall because it is associated with showtimes." });
      }

      _uow.Halls.Delete(hall);
      await _uow.SaveAsync();
      TempData["success"] = "Hall deleted successfully";
      return Json(new { success = true });
    }

    // ─── View Seat Map ────────────────────────────────────────────────────────

    [HttpGet]
    public async Task<IActionResult> ViewMap(int id)
    {
      var hall = await _uow.Halls.GetAsync(h => h.Id == id);
      if (hall is null)
        return NotFound();

      return PartialView("_ViewHallMapModal", hall);
    }

    // ─── Helpers ──────────────────────────────────────────────────────────────

    /// <summary>
    /// Checks whether a hall with the same name AND same type already exists.
    /// On edit, pass excludedId to skip the hall being edited.
    /// </summary>
    private async Task<bool> IsHallExist(string name, HallType? type = null, int excludedId = 0)
    {
      return await _uow.Halls.AnyAsync(h =>
          h.Name.ToLower() == name.Trim().ToLower()
          && (type == null || h.Type == type)
          && h.Id != excludedId);
    }
  }
}
