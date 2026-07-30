using Microsoft.AspNetCore.Mvc;
using Ticketa.Core.DTOs.Notifications;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Authorization;
using static Ticketa.Core.Helpers.Permissions;

namespace Ticketa.Web.Controllers
{
  public class DashboardController(
      IDashboardService dashboardService,
      INotificationService notificationService,
      IShowtimeService showtimeService) : Controller
  {
    [RequirePermission(Dashboard.View)]
    public async Task<IActionResult> Index(CancellationToken ct)
    {
      var summary = await dashboardService.GetDashboardSummaryAsync(ct);
      return View(summary);
    }

    [RequirePermission(Dashboard.View)]
    [HttpGet("Dashboard/NotificationSummary")]
    public async Task<IActionResult> NotificationSummary(CancellationToken ct)
    {
      var notifications = await notificationService.GetNotificationCenterAsync(ct);
      return Json(notifications);
    }

    [RequirePermission(Dashboard.View)]
    [HttpGet("Dashboard/Summary")]
    public async Task<IActionResult> Summary(CancellationToken ct)
    {
      var summary = await dashboardService.GetDashboardSummaryAsync(ct);
      return Json(summary);
    }

    [RequirePermission(Dashboard.View)]
    [HttpGet("Dashboard/Timeline")]
    public async Task<IActionResult> Timeline(DateOnly? date, CancellationToken ct)
    {
      var d = date ?? DateOnly.FromDateTime(DateTime.UtcNow);
      var result = await showtimeService.GetByDateAsync(d, ct);
      return Json(result);
    }
  }
}
