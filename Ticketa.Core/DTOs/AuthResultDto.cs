namespace Ticketa.Core.DTOs
{
  public class AuthResultDto
  {
    public bool Succeeded { get; set; }
    public string? AccessToken { get; set; }
    public string? RefreshToken { get; set; }
    public string? Message { get; set; }

    public static AuthResultDto Success(string accessToken, string refreshToken) =>
      new() { Succeeded = true, AccessToken = accessToken, RefreshToken = refreshToken };

    public static AuthResultDto Failure(string message) =>
      new() { Succeeded = false, Message = message };
  }
}
