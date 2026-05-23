using System.ComponentModel.DataAnnotations;

namespace Ticketa.Core.DTOs
{
  public class RegisterDto
  {
    [Required, EmailAddress]
    public string Email { get; set; } = string.Empty;
    [Required, MinLength(8)]
    public string Password { get; set; } = string.Empty;
    public DateOnly DateOfBirth { get; set; }
  }
}
