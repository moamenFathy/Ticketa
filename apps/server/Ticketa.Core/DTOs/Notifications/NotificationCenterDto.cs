namespace Ticketa.Core.DTOs.Notifications
{
    public class NotificationCenterDto
    {
        public List<ShowtimeNotificationItemDto> SoldOut { get; set; } = [];
        public List<ShowtimeNotificationItemDto> CurrentlyRunning { get; set; } = [];
        public List<ShowtimeNotificationItemDto> RecentlyCompleted { get; set; } = [];
    }
}
