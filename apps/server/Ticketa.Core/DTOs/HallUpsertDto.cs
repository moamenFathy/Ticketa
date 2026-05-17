using System.ComponentModel.DataAnnotations;
using Ticketa.Core.Enums;

namespace Ticketa.Core.DTOs
{
  public class HallUpsertDto
  {
    public int Id { get; set; }

    [Required(ErrorMessage = "Hall name is required.")]
    public string Name { get; set; } = string.Empty;

    [Required]
    public HallType Type { get; set; }
  }
}
