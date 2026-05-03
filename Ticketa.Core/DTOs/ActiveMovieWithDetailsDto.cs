namespace Ticketa.Core.DTOs
{
  public class ActiveMovieWithDetailsDto
  {
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? PosterPath { get; set; }
    public double VoteAverage { get; set; }
    public int Runtime { get; set; }
    public List<string> Genres { get; set; } = new();
  }
}
