namespace Ticketa.Core.DTOs.Notifications
{
    public class ShowtimeNotificationItemDto
    {
        public int ShowtimeId { get; set; }
        public string MovieTitle { get; set; } = "";
        public string HallName { get; set; } = "";
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public DateTime? ArchivedAt { get; set; }
    }
}
