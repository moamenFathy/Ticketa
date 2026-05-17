using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Configuration
{
  public class BookedSeatConfiguration : IEntityTypeConfiguration<BookedSeat>
  {
    public void Configure(EntityTypeBuilder<BookedSeat> builder)
    {
      builder.HasKey(s => s.Id);

      builder.Property(s => s.Category).HasConversion<string>();
      builder.Property(s => s.Price).HasColumnType("decimal(10,2)");

      builder.HasIndex(s => new { s.ShowtimeId, s.Row, s.SeatNumber }).IsUnique();

      builder.HasOne(s => s.Booking)
             .WithMany(b => b.BookedSeats)
             .HasForeignKey(s => s.BookingId)
             .OnDelete(DeleteBehavior.Cascade);

      builder.HasOne(s => s.Showtime)
             .WithMany()
             .HasForeignKey(s => s.ShowtimeId)
             .OnDelete(DeleteBehavior.Restrict);
    }
  }
}
