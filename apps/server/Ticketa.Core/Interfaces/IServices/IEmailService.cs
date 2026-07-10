namespace Ticketa.Core.Interfaces.IServices
{
  public interface IEmailService
  {
    Task SendEmailAsync(string to, string subject, string htmlBody);

    Task SendEmailWithInlineImageAsync(
        string to, string subject, string htmlBody,
        byte[] imageBytes, string contentId, CancellationToken ct = default);
  }
}
