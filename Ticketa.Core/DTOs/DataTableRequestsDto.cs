namespace Ticketa.Core.DTOs
{
  public class DataTableRequestsDto
  {
    public int Draw { get; set; }
    public int Start { get; set; }
    public int Length { get; set; }
    public string? Search { get; set; }
    public int OrderColumn { get; set; }
    public string OrderDir { get; set; } = "asc";
  }
}
