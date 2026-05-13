namespace Ticketa.Core.DTOs
{
  public class MovieShowtimeDto
  {
    public int MovieId { get; set; }
    public int TmdbId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? PosterPath { get; set; }
    public List<ShowtimeListItemDto> Showtimes { get; set; } = [];
    public int ShowtimeCount => Showtimes.Count;
  }
}
