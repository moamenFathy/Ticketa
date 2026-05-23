using System.ComponentModel.DataAnnotations;

namespace Ticketa.Core.DTOs
{
  public class ResendConfirmDto
  {
    [Required, EmailAddress]
    public string Email { get; set; } = string.Empty;
  }
}
