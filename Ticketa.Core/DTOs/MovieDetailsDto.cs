namespace Ticketa.Core.DTOs
{
  public class MovieDetailsDto : ActiveMovieWithDetailsDto
  {
    public int TmdbId { get; set; }
    public string ImdbId { get; set; } = string.Empty;
  }
}
