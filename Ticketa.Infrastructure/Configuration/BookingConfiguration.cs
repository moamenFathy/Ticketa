using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Configuration
{
  public class BookingConfiguration : IEntityTypeConfiguration<Booking>
  {
    public void Configure(EntityTypeBuilder<Booking> builder)
    {
      builder.HasKey(b => b.Id);

      builder.Property(b => b.UserId).IsRequired();
      builder.Property(b => b.BookingRefrence).IsRequired().HasMaxLength(30);
      builder.Property(b => b.TotalAmount).HasColumnType("decimal(10,2)");
      builder.Property(b => b.Status).HasConversion<string>();

      builder.HasOne(b => b.User)
             .WithMany()
             .HasForeignKey(b => b.UserId)
             .OnDelete(DeleteBehavior.Restrict);

      builder.HasOne(b => b.Showtime)
             .WithMany()
             .HasForeignKey(b => b.ShowtimeId)
             .OnDelete(DeleteBehavior.Restrict);
    }
  }
}
