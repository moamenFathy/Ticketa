using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbMovieDetailDto : TmdbMovieDto
  {
    [JsonPropertyName("runtime")]
    public int Runtime { get; set; }

    [JsonPropertyName("genres")]
    public List<TmdbGenreDto> Genres { get; set; } = new();
  }
}
