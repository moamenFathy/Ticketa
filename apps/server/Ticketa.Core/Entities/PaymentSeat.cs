namespace Ticketa.Core.Entities
{
  public class PaymentSeat
  {
    public int Id { get; set; }
    public int PaymentId { get; set; }
    public int Row { get; set; }
    public int SeatNumber { get; set; }
    public decimal UnitPrice { get; set; }

    public Payment Payment { get; set; } = null!;
  }
}
