using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Authorization;
using static Ticketa.Core.Helpers.Permissions;

namespace Ticketa.Web.Controllers
{
  [RequirePermission(Payments.View)]
  public class PaymentsController(IPaymentManagementService paymentManagementService) : Controller
  {
    public IActionResult Index() => View();

    [HttpGet]
    public async Task<IActionResult> GetAll(
    [FromQuery] DataTableRequestsDto request,
    [FromQuery(Name = "search[value]")] string? searchValue = null,
    [FromQuery(Name = "order[0][column]")] int orderColumn = 0,
    [FromQuery(Name = "order[0][dir]")] string orderDir = "asc")
    {
      var result = await paymentManagementService.GetAllAsync(request, searchValue, orderColumn, orderDir);
      return Json(result);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequirePermission(Payments.Refund)]
    public async Task<IActionResult> Refund(int id)
    {
      var (success, message) = await paymentManagementService.RefundAsync(id);
      return Json(new { success, message });
    }
  }
}
