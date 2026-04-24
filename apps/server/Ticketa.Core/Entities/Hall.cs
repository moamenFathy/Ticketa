using System.ComponentModel.DataAnnotations;

namespace Ticketa.Core.Entities;

public class Hall
{
  public int Id { get; set; }
  [Required]
  public string Name { get; set; } = string.Empty;
  [Required, Range(1, int.MaxValue, ErrorMessage = "Total seats must be greater than 0")]
  public int TotalSeats { get; set; }

  public ICollection<Showtime> Showtimes { get; set; } = new List<Showtime>();
}
