namespace Ticketa.Core.DTOs
{
  public class MovieImportResultDto
  {
    public List<string> ImportedTitles { get; set; } = new();

    public int SkippedCount { get; set; }

    public int FailedCount { get; set; }
  }
}
