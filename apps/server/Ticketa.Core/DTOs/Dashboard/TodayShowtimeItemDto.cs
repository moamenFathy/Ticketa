using Ticketa.Core.Enums;

namespace Ticketa.Core.DTOs.Dashboard
{
    public class TodayShowtimeItemDto
    {
        public int ShowtimeId { get; set; }
        public string MovieTitle { get; set; } = "";
        public string HallName { get; set; } = "";
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public ShowtimeStatus Status { get; set; }
        public int BookedSeats { get; set; }
        public int VisibleSeats { get; set; }
        public int OccupancyPercent => VisibleSeats > 0 ? (int)Math.Round((double)BookedSeats / VisibleSeats * 100) : 0;
    }
}
