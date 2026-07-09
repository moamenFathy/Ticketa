namespace Ticketa.Core.DTOs
{
  public class TopBookedMovieDto
  {
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Overview { get; set; } = string.Empty;
    public string PosterPath { get; set; } = string.Empty;
    public string BackdropPath { get; set; } = string.Empty;
    public double VoteAverage { get; set; }
    public List<string> Genres { get; set; } = [];
    public int Runtime { get; set; }
    public int TicketsSold { get; set; }
    public decimal TotalRevenue { get; set; }
  }
}
