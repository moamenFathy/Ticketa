using Ticketa.Core.Enums;

namespace Ticketa.Core.Entities
{
  public class Payment
  {
    public int Id { get; set; }
    public string StripePaymentIntentId { get; set; } = string.Empty;
    public string ClientSecret { get; set; } = string.Empty;
    public string UserId { get; set; } = string.Empty;
    public int ShowtimeId { get; set; }
    public decimal TotalAmount { get; set; }
    public string Currency { get; set; } = "EGP";
    public PaymentStatus Status { get; set; } = PaymentStatus.Pending;
    public string SeatHash { get; set; } = string.Empty;
    public int SeatCount { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? CompletedAt { get; set; }
    public DateTime? RefundedAt { get; set; }

    public AppUser User { get; set; } = null!;
    public Showtime Showtime { get; set; } = null!;
    public ICollection<PaymentSeat> PaymentSeats { get; set; } = new List<PaymentSeat>();
  }
}
