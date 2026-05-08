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
    public DbSet<Cast> Casts { get; set; }
    public DbSet<Showtime> Showtimes { get; set; }

    public ApplicationDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder)
    {
      base.OnModelCreating(builder);

      builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
    }
  }
}
