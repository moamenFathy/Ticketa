namespace Ticketa.Core.DTOs
{
  public class ActiveMovieWithDetailsDto
  {
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Overview { get; set; } = string.Empty;
    public string? PosterPath { get; set; }
    public string? TrailerKey { get; set; }
    public string? BackdropPath { get; set; }
    public double VoteAverage { get; set; }
    public int Runtime { get; set; }
    public DateOnly? ReleaseDate { get; set; }
    public string Language { get; set; } = string.Empty;
    public List<string> Genres { get; set; } = new();
    public List<TmdbCastMemberDto> Cast { get; set; } = new();
  }
}
