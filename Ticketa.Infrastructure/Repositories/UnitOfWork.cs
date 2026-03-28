using Ticketa.Core.Interfaces;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class UnitOfWork : IUnitOfWork
  {
    private readonly ApplicationDbContext _context;

    public UnitOfWork(ApplicationDbContext context)
    {
      _context = context;
    }

    public async Task SaveAsync()
    {
      await _context.SaveChangesAsync();
    }

    public void Dispose()
    {
      _context.Dispose();
    }
  }
}
