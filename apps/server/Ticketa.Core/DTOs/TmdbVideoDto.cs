using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbVideoDto
  {
    [JsonPropertyName("Key")]
    public string Key { get; set; }
    [JsonPropertyName("site")]
    public string Site { get; set; }
    [JsonPropertyName("type")]
    public string Type { get; set; }
    [JsonPropertyName("official")]
    public bool Official { get; set; }
  }
}
