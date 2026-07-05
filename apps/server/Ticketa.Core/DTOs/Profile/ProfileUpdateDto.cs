using System.ComponentModel.DataAnnotations;

namespace Ticketa.Core.DTOs.Profile
{
  public class ProfileUpdateDto
  {
    [StringLength(50)] public string FirstName { get; set; } = "";
    [StringLength(50)] public string LastName { get; set; } = "";
    public DateOnly DateOfBirth { get; set; }
    public string Theme { get; set; } = "light";
  }
}
