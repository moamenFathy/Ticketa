using Ticketa.Core.Enums;

namespace Ticketa.Core.Entities
{
  public class Movie
  {
    public int Id { get; set; }
    public int TmdbId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Overview { get; set; } = string.Empty;
    public string PosterPath { get; set; } = string.Empty;   // relative path from TMDB
    public string BackdropPath { get; set; } = string.Empty;
    public string? TrailerKey { get; set; }  // YouTube video key from TMDB
    public double VoteAverage { get; set; }
    public DateTime ReleaseDate { get; set; }
    public int RuntimeMinutes { get; set; }
    public string Language { get; set; } = string.Empty;
    public MovieStatus Status { get; set; } = MovieStatus.Active;
    public DateTime ImportedAt { get; set; } = DateTime.UtcNow;

    public ICollection<Genre> Genres { get; set; } = new List<Genre>();
    public ICollection<Cast> Casts { get; set; } = new List<Cast>();
  }
}
