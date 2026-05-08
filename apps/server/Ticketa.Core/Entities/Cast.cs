namespace Ticketa.Core.Entities
{
  public class Cast
  {
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? ProfilePath { get; set; }
    public string Character { get; set; } = string.Empty;
    public int Order { get; set; }

    public int MovieId { get; set; }
    public Movie Movie { get; set; } = null!;
  }
}
