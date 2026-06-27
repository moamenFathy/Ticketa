using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System.Reflection;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Data
{
  public class ApplicationDbContext(DbContextOptions options) : IdentityDbContext<AppUser, AppRole, string>(options)
  {
    public DbSet<Hall> Halls { get; set; }
    public DbSet<Movie> Movies { get; set; }
    public DbSet<Genre> Genres { get; set; }
    public DbSet<CastMember> Casts { get; set; }
    public DbSet<Showtime> Showtimes { get; set; }
    public DbSet<Booking> Bookings { get; set; }
    public DbSet<BookedSeat> BookedSeats { get; set; }
    public DbSet<Payment> Payments { get; set; }
    public DbSet<PaymentSeat> PaymentSeats { get; set; }

    protected override void OnModelCreating(ModelBuilder builder)
    {
      base.OnModelCreating(builder);

      builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
    }
  }
}
