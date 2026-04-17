using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{

  public class GenericRepository<T> : IGenericRepository<T> where T : class
  {
    protected readonly ApplicationDbContext _context;
    private readonly DbSet<T> _dbSet;

    public GenericRepository(ApplicationDbContext context)
    {
      _context = context;
      _dbSet = _context.Set<T>();
    }

    public async Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>>? filter = null, params string[] includes)
    {
      IQueryable<T> query = _dbSet;

      if (filter is not null)
        query = query.Where(filter);

      foreach (var include in includes)
      {
        query = query.Include(include);
      }

      return await query.ToListAsync();
    }

    public async Task<T?> GetAsync(Expression<Func<T, bool>> filter, params string[] includes)
    {
      IQueryable<T> query = _dbSet;

      foreach (var includeProperty in includes)
      {
        query = query.Include(includeProperty);
      }

      return await query.FirstOrDefaultAsync(filter);
    }

    public async Task CreateAsync(T entity) => await _dbSet.AddAsync(entity);

    public void Delete(T entity) => _dbSet.Remove(entity);

    public async Task<bool> AnyAsync(Expression<Func<T, bool>> predicate) => await _dbSet.AnyAsync(predicate);

    public async Task CreateRangeAsync(IEnumerable<T> entities) => await _dbSet.AddRangeAsync(entities);
  }
}
