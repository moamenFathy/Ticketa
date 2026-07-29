namespace Ticketa.Core.DTOs.Dashboard
{
    public class DashboardSummaryDto
    {
        public decimal Revenue30Days { get; set; }
        public List<RevenueTrendPointDto> RevenueTrend { get; set; } = [];
        public int BookingsToday { get; set; }
        public int BookingsThisWeek { get; set; }
        public int SoldOutShowtimeCount { get; set; }
        public List<TodayShowtimeItemDto> TodayShowtimes { get; set; } = [];
        public List<TopMovieDto> TopMovies { get; set; } = [];
        public List<RecentActivityItemDto> RecentActivity { get; set; } = [];
        public double AverageOccupancyPercent { get; set; }
    }
}
