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

    public async Task SendEmailWithInlineImageAsync(
        string to, string subject, string htmlBody,
        byte[] imageBytes, string contentId, CancellationToken ct = default)
    {
      var message = new MimeMessage();
      message.From.Add(new MailboxAddress(_settings.FromName, _settings.FromEmail));
      message.To.Add(MailboxAddress.Parse(to));
      message.Subject = subject;

      var builder = new BodyBuilder { HtmlBody = htmlBody };
      var image = builder.LinkedResources.Add("ticket-qr.png", imageBytes, new ContentType("image", "png"));
      image.ContentId = contentId;

      message.Body = builder.ToMessageBody();

      using var client = new SmtpClient();
      await client.ConnectAsync(_settings.Host, _settings.Port, SecureSocketOptions.StartTls, ct);
      await client.AuthenticateAsync(_settings.Username, _settings.Password, ct);
      await client.SendAsync(message, ct);
      await client.DisconnectAsync(true, ct);
    }
  }
}
