using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbPopularResponseDto
  {
    [JsonPropertyName("results")]
    public List<TmdbMovieDto> Results { get; set; } = new();
  }
}
