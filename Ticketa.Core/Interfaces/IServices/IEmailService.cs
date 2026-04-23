namespace Ticketa.Core.Interfaces.IServices
{
  public interface IEmailService
  {
    Task SendEmailAsync(string to, string subject, string htmlBody);
  }
}
