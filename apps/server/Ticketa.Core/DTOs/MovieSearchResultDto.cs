namespace Ticketa.Core.DTOs
{
  public class MovieSearchResultDto
  {
    public int Value { get; set; }

    public string Text { get; set; } = string.Empty;

    public string Year { get; set; } = "N/A";

    public string Rating { get; set; } = "0.0";

    public string Poster { get; set; } = string.Empty;

    public string Overview { get; set; } = string.Empty;
  }
}
