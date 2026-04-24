namespace Ticketa.Infrastructure.Service
{
  public class EmailTemplates
  {
    private static string EmailLayout(string title, string content) => $"""
        <div style="background-color: #f3f4f6; padding: 40px 0; font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
            <div style="max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);">
                <div style="background-color: #e11d48; padding: 32px 24px; text-align: center;">
                    <h1 style="color: #ffffff; font-size: 28px; margin: 0; font-weight: 800; letter-spacing: -0.5px;">🎬 Ticketa</h1>
                </div>
                <div style="padding: 40px 32px;">
                    <h2 style="color: #1e293b; font-size: 24px; margin-top: 0; margin-bottom: 24px; font-weight: 700; text-align: center;">{title}</h2>
                    <div style="color: #475569; font-size: 16px; line-height: 1.6; text-align: center;">
                        {content}
                    </div>
                </div>
                <div style="background-color: #f8fafc; color: #94a3b8; font-size: 13px; text-align: center; padding: 24px; border-top: 1px solid #f1f5f9;">
                    <p style="margin: 0 0 8px 0;">&copy; {DateTime.Now.Year} Ticketa. All rights reserved.</p>
                    <p style="margin: 0;">If you have any questions, feel free to reply to this email.</p>
                </div>
            </div>
        </div>
    """;
    public static string VerificationCode(string code)
    {
      var content = $"""
            <p>Welcome to Ticketa! Use the verification code below to secure your account. This code is valid for <strong>15 minutes</strong>.</p>
            <div style="
                font-family: 'Courier New', Courier, monospace;
                font-size: 42px;
                font-weight: 700;
                letter-spacing: 8px;
                color: #e11d48;
                text-align: center;
                background: #fff1f2;
                border: 2px dashed #fda4af;
                padding: 24px;
                border-radius: 12px;
                margin: 32px 0;
            ">
                {code}
            </div>
            <p style="font-size: 14px; color: #64748b;">If you didn't create an account, you can safely ignore this email.</p>
        """;
      return EmailLayout("Verify Your Email", content);
    }

    public static string ForgotPassword(string resetLink)
    {
      var content = $"""
            <p>We received a request to reset the password for your Ticketa account. No worries, it happens to the best of us!</p>
            <p>Click the button below to choose a new password. This link will expire in <strong>1 hour</strong>.</p>
            <div style="text-align: center; margin: 32px 0;">
                <a href="{resetLink}" style="
                    background-color: #e11d48;
                    color: #ffffff;
                    padding: 16px 32px;
                    text-decoration: none;
                    border-radius: 12px;
                    font-weight: 600;
                    font-size: 16px;
                    display: inline-block;
                    box-shadow: 0 4px 6px -1px rgba(225, 29, 72, 0.3);
                ">Reset Your Password</a>
            </div>
            <p style="font-size: 14px; color: #64748b;">If you didn't request a password reset, please ignore this email or contact support if you have concerns.</p>
        """;
      return EmailLayout("Reset Your Password", content);
    }
  }
}
