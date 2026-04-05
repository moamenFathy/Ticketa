using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Data
{
  public class ApplicationDbContext : IdentityDbContext<AppUser>
  {
    public ApplicationDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder)
    {
      base.OnModelCreating(builder);
    }
  }
}
