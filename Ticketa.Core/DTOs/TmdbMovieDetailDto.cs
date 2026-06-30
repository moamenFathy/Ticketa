using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbMovieDetailDto : TmdbMovieDto
  {
    [JsonPropertyName("imdb_id")]
    public string ImdbId { get; set; } = string.Empty;

    [JsonPropertyName("runtime")]
    public int Runtime { get; set; }

    [JsonPropertyName("genres")]
    public List<TmdbGenreDto> Genres { get; set; } = new();
  }
}
