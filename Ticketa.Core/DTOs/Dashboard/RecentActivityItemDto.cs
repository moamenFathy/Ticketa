namespace Ticketa.Core.DTOs.Dashboard
{
    public class RecentActivityItemDto
    {
        public string Type { get; set; } = "";
        public string Description { get; set; } = "";
        public decimal? Amount { get; set; }
        public DateTime Timestamp { get; set; }
    }
}
