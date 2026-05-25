using System.ComponentModel.DataAnnotations;

namespace Ticketa.Core.DTOs
{
  public class GoogleAuthDto
  {
    [Required]
    public string IdToken { get; set; } = string.Empty;
  }
}
