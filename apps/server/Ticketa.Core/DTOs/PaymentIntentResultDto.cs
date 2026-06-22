namespace Ticketa.Core.DTOs
{
  public class PaymentIntentResultDto
  {
    public string ClientSecret { get; set; } = string.Empty;
    public string PaymentIntentId { get; set; } = string.Empty;
    public decimal TotalAmount { get; set; }
  }
}
