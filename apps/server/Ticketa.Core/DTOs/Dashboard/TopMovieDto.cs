namespace Ticketa.Core.DTOs.Dashboard
{
    public class TopMovieDto
    {
        public int MovieId { get; set; }
        public string Title { get; set; } = "";
        public string? PosterPath { get; set; }
        public int BookingCount { get; set; }
    }
}
