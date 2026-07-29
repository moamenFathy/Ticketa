using Microsoft.EntityFrameworkCore;
using Ticketa.Core.DTOs;
using Ticketa.Core.DTOs.Dashboard;
using Ticketa.Core.Enums;
using Ticketa.Core.Helpers;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Service
{
    public class DashboardService(
        ApplicationDbContext context,
        IMoviesService moviesService,
        TimeConversions timeConversions) : IDashboardService
    {
        public async Task<DashboardSummaryDto> GetDashboardSummaryAsync(CancellationToken ct = default)
        {
            var now = DateTime.UtcNow;
            var localNow = timeConversions.ConvertFromUtc(now);
            var localToday = localNow.Date;

            var todayStart = timeConversions.ConvertToUtc(localToday);
            var todayEnd = timeConversions.ConvertToUtc(localToday.AddDays(1));
            var weekStart = timeConversions.ConvertToUtc(localToday.AddDays(-(int)localToday.DayOfWeek));
            var cutoff30 = now.AddDays(-30);

            var revenue30Days = await context.Payments
                .Where(p => p.Status == PaymentStatus.Completed && p.CompletedAt >= cutoff30)
                .SumAsync(p => (decimal?)p.TotalAmount, ct) ?? 0;

            var revenueData = await context.Payments
                .Where(p => p.Status == PaymentStatus.Completed && p.CompletedAt >= cutoff30)
                .Select(p => new { Date = p.CompletedAt!.Value.Date, p.TotalAmount })
                .ToListAsync(ct);

            var revenueTrend = revenueData
                .GroupBy(p => DateOnly.FromDateTime(p.Date))
                .Select(g => new RevenueTrendPointDto { Date = g.Key, Amount = g.Sum(p => p.TotalAmount) })
                .OrderBy(x => x.Date)
                .ToList();

            var bookingsToday = await context.Bookings
                .CountAsync(b => b.BookedAt >= todayStart && b.BookedAt < todayEnd, ct);

            var bookingsThisWeek = await context.Bookings
                .CountAsync(b => b.BookedAt >= weekStart, ct);

            var soldOutCount = await context.Showtimes
                .CountAsync(s => s.Status == ShowtimeStatus.SoldOut && !s.IsArchived, ct);

            var showtimes = await context.Showtimes
                .Where(s => s.StartTime >= todayStart && s.StartTime < todayEnd && !s.IsArchived)
                .Include(s => s.Movie)
                .Include(s => s.Hall)
                .OrderBy(s => s.StartTime)
                .ToListAsync(ct);

            var showtimeIds = showtimes.Select(s => s.Id).ToList();

            var bookedCounts = showtimeIds.Count > 0
                ? await context.BookedSeats
                    .Where(bs => showtimeIds.Contains(bs.ShowtimeId))
                    .GroupBy(bs => bs.ShowtimeId)
                    .Select(g => new { ShowtimeId = g.Key, Count = g.Count() })
                    .ToDictionaryAsync(x => x.ShowtimeId, x => x.Count, ct)
                : [];

            var todayShowtimes = showtimes.Select(s => new TodayShowtimeItemDto
            {
                ShowtimeId = s.Id,
                MovieTitle = s.Movie.Title,
                HallName = s.Hall.Name,
                StartTime = timeConversions.EnsureUtcKind(s.StartTime),
                EndTime = timeConversions.EnsureUtcKind(s.EndTime),
                Status = s.Status,
                BookedSeats = bookedCounts.GetValueOrDefault(s.Id, 0),
                VisibleSeats = HallTypeHelper.GetTemplate(s.Hall.Type).VisibleSeatCount
            }).ToList();

            var topMovies = (await moviesService.GetTopBookedMoviesAsync(5, ct))
                .Select(m => new TopMovieDto
                {
                    MovieId = m.Id,
                    Title = m.Title,
                    PosterPath = m.PosterPath,
                    BookingCount = m.TicketsSold
                })
                .ToList();

            var recentActivity = await context.Payments
                .Where(p => p.Status == PaymentStatus.Completed)
                .OrderByDescending(p => p.CompletedAt)
                .Take(10)
                .Select(p => new RecentActivityItemDto
                {
                    Type = p.RefundedAt != null ? "Refund" : "Payment",
                    Description = p.BookingReference ?? $"Payment #{p.Id}",
                    Amount = p.TotalAmount,
                    Timestamp = p.CompletedAt ?? p.CreatedAt
                })
                .ToListAsync(ct);

            var activeShowtimes = await context.Showtimes
                .Where(s => s.Status == ShowtimeStatus.Scheduled && !s.IsArchived)
                .Include(s => s.Hall)
                .ToListAsync(ct);

            var activeShowtimeIds = activeShowtimes.Select(s => s.Id).ToList();

            var seatCounts = activeShowtimeIds.Count > 0
                ? await context.BookedSeats
                    .Where(bs => activeShowtimeIds.Contains(bs.ShowtimeId))
                    .GroupBy(bs => bs.ShowtimeId)
                    .Select(g => new { ShowtimeId = g.Key, Count = g.Count() })
                    .ToDictionaryAsync(x => x.ShowtimeId, x => x.Count, ct)
                : [];

            var averageOccupancyPercent = activeShowtimes.Count > 0
                ? activeShowtimes.Average(s =>
                {
                    var visible = HallTypeHelper.GetTemplate(s.Hall.Type).VisibleSeatCount;
                    var booked = seatCounts.GetValueOrDefault(s.Id, 0);
                    return visible > 0 ? (double)booked / visible * 100 : 0;
                })
                : 0;

            return new DashboardSummaryDto
            {
                Revenue30Days = revenue30Days,
                RevenueTrend = revenueTrend,
                BookingsToday = bookingsToday,
                BookingsThisWeek = bookingsThisWeek,
                SoldOutShowtimeCount = soldOutCount,
                TodayShowtimes = todayShowtimes,
                TopMovies = topMovies,
                RecentActivity = recentActivity,
                AverageOccupancyPercent = Math.Round(averageOccupancyPercent, 1)
            };
        }
    }
}
