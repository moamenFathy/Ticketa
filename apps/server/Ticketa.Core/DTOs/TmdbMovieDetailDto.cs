using System.Text.Json.Serialization;

namespace Ticketa.Core.DTOs
{
  public class TmdbMovieDetailDto
  {
    [JsonPropertyName("runtime")]
    public int Runtime { get; set; }
  }
}
