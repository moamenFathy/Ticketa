using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Configuration
{
  public class ShowtimeConfiguration : IEntityTypeConfiguration<Showtime>
  {
    public void Configure(EntityTypeBuilder<Showtime> builder)
    {
      builder.Property(s => s.Price)
             .HasColumnType("decimal(18,2)")
             .IsRequired();

      builder.Property(s => s.Status)
             .HasConversion<int>();

      builder.HasOne(m => m.Movie)
             .WithMany()
             .HasForeignKey(s => s.MovieId)
             .OnDelete(DeleteBehavior.Restrict);

      builder.HasOne(h => h.Hall)
             .WithMany(s => s.Showtimes)
             .HasForeignKey(s => s.HallId)
             .OnDelete(DeleteBehavior.Restrict);
    }
  }
}
