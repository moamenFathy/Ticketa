using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbMovieDto
  {
    [JsonPropertyName("id")]
    public int TmdbId { get; set; }

    [JsonPropertyName("title")]
    public string Title { get; set; } = string.Empty;

    [JsonPropertyName("overview")]
    public string Overview { get; set; } = string.Empty;

    [JsonPropertyName("poster_path")]
    public string PosterPath { get; set; } = string.Empty;

    [JsonPropertyName("backdrop_path")]
    public string BackdropPath { get; set; } = string.Empty;

    [JsonPropertyName("vote_average")]
    public double VoteAverage { get; set; }

    [JsonPropertyName("release_date")]
    public string ReleaseDate { get; set; } = string.Empty; // TMDB returns this as a string in "YYYY-MM-DD" format

    [JsonPropertyName("original_language")]
    public string Language { get; set; } = string.Empty;
  }
}
