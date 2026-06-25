using System.ComponentModel.DataAnnotations;

namespace Ticketa.Web.ViewModels
{
  public class AdminUserUpsertVM
  {
    public string? Id { get; set; } = string.Empty;
    [Required]
    public string FirstName { get; set; } = string.Empty;
    [Required]
    public string LastName { get; set; } = string.Empty;
    [Required, EmailAddress]
    public string Email { get; set; } = string.Empty;
    [MinLength(8)]
    public string? Password { get; set; }
    [Compare(nameof(Password), ErrorMessage = "The password and confirmation password do not match.")]
    public string? ConfirmPassword { get; set; }
    [Required]
    public string Role { get; set; } = string.Empty;
    public List<string> AvailableRoles { get; set; } = [];
  }
}
