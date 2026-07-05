namespace Ticketa.Core.DTOs.Profile
{
  public class ProfileDto
  {
    public string FirstName { get; set; } = "";
    public string LastName { get; set; } = "";
    public string Email { get; set; } = "";
    public DateOnly DateOfBirth { get; set; }
    public string Theme { get; set; } = "light";
  }
}
