using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Settings;

namespace Ticketa.Infrastructure.Service
{
  public class EmailService : IEmailService
  {
    private readonly EmailSettings _settings;

    public EmailService(EmailSettings settings)
    {
      _settings = settings;
    }

    public async Task SendEmailAsync(string toEmail, string subject, string htmlBody)
    {
      var message = new MimeMessage();

      // "Ticketa" is what shows in the inbox
      message.From.Add(new MailboxAddress(_settings.FromName, _settings.FromEmail));
      message.To.Add(MailboxAddress.Parse(toEmail));
      message.Subject = subject;

      message.Body = new BodyBuilder
      {
        HtmlBody = htmlBody
      }.ToMessageBody();

      using var client = new SmtpClient();

      await client.ConnectAsync(_settings.Host, _settings.Port, SecureSocketOptions.StartTls);
      await client.AuthenticateAsync(_settings.Username, _settings.Password);
      await client.SendAsync(message);
      await client.DisconnectAsync(true);

    }
  }
}
