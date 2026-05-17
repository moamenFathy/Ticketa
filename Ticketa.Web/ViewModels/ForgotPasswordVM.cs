using System.ComponentModel.DataAnnotations;

namespace Ticketa.Web.ViewModels
{
  public class ForgotPasswordVM
  {
    [Required, EmailAddress]
    public string Email { get; set; } = string.Empty;
  }
}
