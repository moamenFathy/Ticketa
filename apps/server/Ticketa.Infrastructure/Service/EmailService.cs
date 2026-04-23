using Resend;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Settings;

namespace Ticketa.Infrastructure.Service
{
  public class EmailService : IEmailService
  {
    private readonly IResend _resend;
    private readonly EmailSettings _settings;

    public EmailService(IResend resend, EmailSettings settings)
    {
      _resend = resend;
      _settings = settings;
    }

    public Task SendEmailAsync(string toEmail, string subject, string htmlBody)
    {
      var message = new EmailMessage();

      message.From = $"{_settings.FromName} <{_settings.FromEmail}>";
      message.To.Add(toEmail);
      message.Subject = subject;
      message.HtmlBody = htmlBody;

      return _resend.EmailSendAsync(message);
    }
  }
}
