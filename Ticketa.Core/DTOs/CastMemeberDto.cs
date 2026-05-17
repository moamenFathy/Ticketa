namespace Ticketa.Core.DTOs
{
  public class CastMemeberDto
  {
    public string Name { get; set; } = string.Empty;
    public string Character { get; set; } = string.Empty;
    public string? ProfilePath { get; set; }
    public int Order { get; set; }
  }
}
