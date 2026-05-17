namespace Ticketa.Core.DTOs
{
  public class MovieDropdownDto
  {
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string PosterPath { get; set; } = string.Empty;
    public int Runtime { get; set; }
  }
}
