using Microsoft.EntityFrameworkCore;
using Ticketa.Core.DTOs.Notifications;
using Ticketa.Core.Enums;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Service
{
    public class NotificationService(
        ApplicationDbContext context) : INotificationService
    {
        public async Task<NotificationCenterDto> GetNotificationCenterAsync(CancellationToken ct = default)
        {
            var now = DateTime.UtcNow;
            var cutoff = now.AddHours(-24);

            var showtimes = await context.Showtimes
                .Where(s =>
                    (s.Status == ShowtimeStatus.SoldOut && !s.IsArchived) ||
                    (s.Status == ShowtimeStatus.Scheduled && !s.IsArchived && s.StartTime <= now && s.EndTime > now) ||
                    (s.Status == ShowtimeStatus.Completed && s.IsArchived && s.ArchivedAt >= cutoff))
                .Include(s => s.Movie)
                .Include(s => s.Hall)
                .ToListAsync(ct);

            var dto = new NotificationCenterDto();

            foreach (var s in showtimes)
            {
                var item = new ShowtimeNotificationItemDto
                {
                    ShowtimeId = s.Id,
                    MovieTitle = s.Movie.Title,
                    HallName = s.Hall.Name,
                    StartTime = s.StartTime,
                    EndTime = s.EndTime,
                    ArchivedAt = s.ArchivedAt
                };

                if (s.Status == ShowtimeStatus.SoldOut && !s.IsArchived)
                    dto.SoldOut.Add(item);
                else if (s.Status == ShowtimeStatus.Scheduled && !s.IsArchived && s.StartTime <= now && s.EndTime > now)
                    dto.CurrentlyRunning.Add(item);
                else if (s.Status == ShowtimeStatus.Completed && s.IsArchived && s.ArchivedAt >= cutoff)
                    dto.RecentlyCompleted.Add(item);
            }

            dto.RecentlyCompleted = dto.RecentlyCompleted
                .OrderByDescending(x => x.ArchivedAt ?? DateTime.MinValue)
                .ToList();

            return dto;
        }
    }
}
