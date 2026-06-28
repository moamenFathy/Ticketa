namespace Ticketa.Core.DTOs.Payments
{
  public class PaymentListItemDto
  {
    public int Id { get; set; }
    public string StripePaymentIntentId { get; set; } = string.Empty;
    public string UserName { get; set; } = string.Empty;
    public string UserEmail { get; set; } = string.Empty;
    public string MovieTitle { get; set; } = string.Empty;
    public decimal TotalAmount { get; set; }
    public string Status { get; set; } = string.Empty;
    public string BookingReference { get; set; } = string.Empty;
    public string BookingStatus { get; set; } = string.Empty;
    public DateTime? RefundedAt { get; set; }
    public DateTime CreatedAt { get; set; }
  }
}
