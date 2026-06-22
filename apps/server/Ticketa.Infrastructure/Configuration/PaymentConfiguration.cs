using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Configuration
{
  public class PaymentConfiguration : IEntityTypeConfiguration<Payment>
  {
    public void Configure(EntityTypeBuilder<Payment> builder)
    {
      builder.HasKey(p => p.Id);

      builder.Property(p => p.StripePaymentIntentId).IsRequired().HasMaxLength(128);
      builder.Property(p => p.ClientSecret).IsRequired().HasMaxLength(500);
      builder.Property(p => p.UserId).IsRequired();
      builder.Property(p => p.TotalAmount).HasColumnType("decimal(10,2)");
      builder.Property(p => p.Currency).IsRequired().HasMaxLength(3);
      builder.Property(p => p.Status).HasConversion<string>().HasMaxLength(20);
      builder.Property(p => p.SeatHash).IsRequired().HasMaxLength(256);

      builder.HasIndex(p => new { p.UserId, p.ShowtimeId, p.SeatHash }).IsUnique().HasFilter("[Status] = 'Pending'");
      builder.HasIndex(p => p.StripePaymentIntentId).IsUnique();

      builder.HasOne(p => p.User)
             .WithMany()
             .HasForeignKey(p => p.UserId)
             .OnDelete(DeleteBehavior.Restrict);

      builder.HasOne(p => p.Showtime)
             .WithMany()
             .HasForeignKey(p => p.ShowtimeId)
             .OnDelete(DeleteBehavior.Restrict);
    }
  }
}
