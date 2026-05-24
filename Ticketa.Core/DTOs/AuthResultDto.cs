namespace Ticketa.Core.DTOs
{
  public class AuthResultDto
  {
    public bool Succeeded { get; set; }
    public string? AccessToken { get; set; }
    public string? RefreshToken { get; set; }
    public string? Message { get; set; }
    public UserDto? User { get; set; }

    public static AuthResultDto Success(string accessToken, string refreshToken, UserDto user) =>
      new() { Succeeded = true, AccessToken = accessToken, RefreshToken = refreshToken, User = user };

    public static AuthResultDto Failure(string message) =>
      new() { Succeeded = false, Message = message };
  }
}
