using System.ComponentModel.DataAnnotations;

namespace Ticketa.Core.DTOs.Profile
{
  public class ChangePasswordDto
  {
    [Required] public string CurrentPassword { get; set; } = "";
    [Required, MinLength(8)] public string NewPassword { get; set; } = "";
    [Required, Compare("NewPassword", ErrorMessage = "Passwords do not match.")]
    public string ConfirmNewPassword { get; set; } = "";
  }
}
