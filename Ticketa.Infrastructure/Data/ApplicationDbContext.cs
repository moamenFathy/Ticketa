using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Data
{
  public class ApplicationDbContext : IdentityDbContext<AppUser>
  {
    public DbSet<Hall> Halls { get; set; }

    public ApplicationDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder)
    {
      base.OnModelCreating(builder);

      builder.Entity<Hall>().HasData(
        new Hall { Id = 1, Name = "Main Hall", TotalSeats = 200 },
        new Hall { Id = 2, Name = "VIP Lounge", TotalSeats = 50 }
      );
    }
  }
}
