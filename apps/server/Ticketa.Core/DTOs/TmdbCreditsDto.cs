using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbCreditsDto
  {
    [JsonPropertyName("cast")]
    public List<TmdbCastMemberDto> Cast { get; set; } = [];
  }
}
