using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbVideoResponseDto
  {
    [JsonPropertyName("results")]
    public List<TmdbVideoDto> Results { get; set; } = new();
  }
}
