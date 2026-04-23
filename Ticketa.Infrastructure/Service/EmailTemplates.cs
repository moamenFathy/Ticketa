namespace Ticketa.Infrastructure.Service
{
  public class EmailTemplates
  {
    public static string VerificationCode(string code) => $"""
        <div style="font-family: sans-serif; max-width: 500px; margin: auto; padding: 32px;">
            <h2 style="color: #e11d48;">🎬 Ticketa — Verify Your Email</h2>
            <p>Use the code below to verify your account. It expires in <strong>15 minutes</strong>.</p>
            <div style="
                font-size: 36px;
                font-weight: bold;
                letter-spacing: 12px;
                text-align: center;
                background: #f3f4f6;
                padding: 24px;
                border-radius: 8px;
                margin: 24px 0;
            ">
                {code}
            </div>
        </div>
    """;
  }
}
