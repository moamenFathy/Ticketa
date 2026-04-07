using System.ComponentModel.DataAnnotations;

namespace Ticketa.Core.Entities;

public class Hall
{
    public int Id { get; set; }
    [Required]
    public string Name { get; set; } = string.Empty;
    [Required]
    public int TotalSeats { get; set; }
}
