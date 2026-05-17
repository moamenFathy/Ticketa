using System.ComponentModel.DataAnnotations;

namespace Ticketa.Web.ViewModels
{
  public class ReigsterVM
  {
    public string Email { get; set; } = string.Empty;
    public DateOnly DateOfBirth { get; set; }
    public string Password { get; set; } = string.Empty;
    [Compare(nameof(Password))]
    public string ConfirmPassword { get; set; } = string.Empty;
  }
}
