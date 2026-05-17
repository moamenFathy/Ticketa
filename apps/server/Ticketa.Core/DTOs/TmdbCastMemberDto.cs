using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbCastMemberDto
  {
    [JsonPropertyName("id")]
    public int Id { get; set; }
    [JsonPropertyName("name")]
    public string Name { get; set; } = string.Empty;
    [JsonPropertyName("character")]
    public string Character { get; set; } = string.Empty;
    [JsonPropertyName("profile_path")]
    public string? ProfilePath { get; set; }
    [JsonPropertyName("order")]
    public int Order { get; set; }
  }
}
