using Ticketa.Core.DTOs.Notifications;

namespace Ticketa.Core.Interfaces.IServices
{
    public interface INotificationService
    {
        Task<NotificationCenterDto> GetNotificationCenterAsync(CancellationToken ct = default);
    }
}
