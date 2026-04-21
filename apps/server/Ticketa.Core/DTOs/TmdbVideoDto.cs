using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbVideoDto
  {
    [JsonPropertyName("Key")]
    public string Key { get; set; } = string.Empty;

    [JsonPropertyName("site")]
    public string Site { get; set; } = string.Empty;

    [JsonPropertyName("type")]
    public string Type { get; set; } = string.Empty;

    [JsonPropertyName("official")]
    public bool Official { get; set; }
  }
}
