using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbCreditsDto
  {
    [JsonPropertyName("cast")]
    public List<TmdbCastMember> Cast { get; set; } = [];
  }
}
