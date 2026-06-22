using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Configuration
{
  public class PaymentSeatConfiguration : IEntityTypeConfiguration<PaymentSeat>
  {
    public void Configure(EntityTypeBuilder<PaymentSeat> builder)
    {
      builder.HasKey(s => s.Id);

      builder.Property(s => s.UnitPrice).HasColumnType("decimal(10,2)");

      builder.HasOne(s => s.Payment)
             .WithMany(p => p.PaymentSeats)
             .HasForeignKey(s => s.PaymentId)
             .OnDelete(DeleteBehavior.Cascade);
    }
  }
}
