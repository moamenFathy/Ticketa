using System.ComponentModel.DataAnnotations;
using Ticketa.Core.Enums;

namespace Ticketa.Core.Entities;

public class Hall
{
  public int Id { get; set; }

  [Required]
  public string Name { get; set; } = string.Empty;

  [Required]
  public HallType Type { get; set; }

  public int TotalRows { get; set; }
  public int SeatsPerRow { get; set; }

  public int TotalSeats => TotalRows * SeatsPerRow;

  public ICollection<Showtime> Showtimes { get; set; } = new List<Showtime>();
}
