namespace Ticketa.Core.DTOs
{
    public class ShowtimeBatchSaveDto
    {
        public string Date { get; set; } = "";
        public List<ShowtimeBatchChangeDto> Changes { get; set; } = [];
    }

    public class ShowtimeBatchChangeDto
    {
        public string Action { get; set; } = ""; // "create", "update", "delete"
        public int? ShowtimeId { get; set; }
        public int? MovieId { get; set; }
        public int? HallId { get; set; }
        public string? StartTime { get; set; }
        public decimal? Price { get; set; }
        public string? ClientId { get; set; } // temp ID on client for matching errors
    }

    public class ShowtimeBatchResultDto
    {
        public bool Success { get; set; }
        public List<ShowtimeBatchErrorDto> Errors { get; set; } = [];
    }

    public class ShowtimeBatchErrorDto
    {
        public string? ClientId { get; set; }
        public int? ShowtimeId { get; set; }
        public string Message { get; set; } = "";
    }
}
