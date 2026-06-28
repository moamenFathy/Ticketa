using Microsoft.AspNetCore.Mvc;
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
    public async Task<IActionResult> GetAll()
    {
      var result = await paymentManagementService.GetAllAsync();
      return Json(new { data = result });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequirePermission(Payments.Refund)]
    public async Task<IActionResult> Refund(int id)
    {
      var (success, message) = await paymentManagementService.RefundAsync(id);

      if (!success)
      {
        TempData["Error"] = message;
        return RedirectToAction(nameof(Index));
      }

      TempData["Success"] = "Payment refunded successfully.";
      return RedirectToAction(nameof(Index));
    }
  }
}
