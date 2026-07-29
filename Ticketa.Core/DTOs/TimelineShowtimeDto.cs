namespace Ticketa.Core.DTOs
{
    public class HallTimelineDto
    {
        public int HallId { get; set; }
        public string HallName { get; set; } = string.Empty;
        public string HallType { get; set; } = string.Empty;
        public List<TimelineShowtimeDto> Showtimes { get; set; } = [];
    }

    public class TimelineShowtimeDto
    {
        public int Id { get; set; }
        public int MovieId { get; set; }
        public string MovieTitle { get; set; } = string.Empty;
        public int RuntimeMinutes { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public decimal Price { get; set; }
        public int Status { get; set; }
        public string? PosterPath { get; set; }
        public string? TrailerKey { get; set; }
        public int TmdbId { get; set; }
        public bool IsArchived { get; set; }
        public bool HasBookings { get; set; }
    }
}
