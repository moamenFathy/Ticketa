using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using Ticketa.Core.Interfaces;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{

  public class Repository<T> : IRepository<T> where T : class
  {
    protected readonly ApplicationDbContext _context;
    private readonly DbSet<T> _dbSet;

    public Repository(ApplicationDbContext context)
    {
      _context = context;
      _dbSet = _context.Set<T>();
    }

    public async Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>>? filter)
    {
      IQueryable<T> query = _dbSet;

      if (filter is not null)
        query = query.Where(filter);

      return await query.ToListAsync();
    }

    public async Task<T?> GetByIdAsync(int id) => await _dbSet.FindAsync(id);

    public async Task CreateAsync(T entity) => await _dbSet.AddAsync(entity);

    public void Delete(T entity) => _dbSet.Remove(entity);

  }
}
