using System.ComponentModel.DataAnnotations;

namespace Ticketa.Core.DTOs
{
  public class ConfirmPaymentDto
  {
    [Required]
    public string PaymentIntentId { get; set; } = string.Empty;
  }
}
