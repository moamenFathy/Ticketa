using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System.Reflection;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Data
{
  public class ApplicationDbContext : IdentityDbContext<AppUser>
  {
    public DbSet<Hall> Halls { get; set; }
    public DbSet<Movie> Movies { get; set; }
    public DbSet<Genre> Genres { get; set; }

    public ApplicationDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder)
    {
      base.OnModelCreating(builder);

      builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

      builder.Entity<Hall>().HasData(
        new Hall { Id = 1, Name = "Main Hall", TotalSeats = 200 },
        new Hall { Id = 2, Name = "VIP Lounge", TotalSeats = 50 }
      );
    }
  }
}
