using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Configuration
{
  public class HallConfiguration : IEntityTypeConfiguration<Hall>
  {
    public void Configure(EntityTypeBuilder<Hall> builder)
    {
      builder.HasData(
  new Hall { Id = 1, Name = "Main Hall", TotalSeats = 200 },
      new Hall { Id = 2, Name = "VIP Lounge", TotalSeats = 50 }
      );
    }
  }
}
