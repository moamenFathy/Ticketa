using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Core.Specifications;
using Ticketa.Infrastructure.Data;
using Ticketa.Infrastructure.Specification;

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

    public async Task<IEnumerable<T>> GetAllAsync()
    {
      IQueryable<T> query = _dbSet;

      return await query.ToListAsync();
    }

    public async Task<T?> GetAsync(Expression<Func<T, bool>> filter)
    {
      IQueryable<T> query = _dbSet;

      return await query.FirstOrDefaultAsync(filter);
    }

    public async Task<IReadOnlyList<T>> GetAllWithSpecAsync(BaseSpecification<T> spec) =>
      await SpecificationEvaluator<T>
              .GetQuery(_dbSet, spec)
              .ToListAsync();

    public async Task CreateAsync(T entity) => await _dbSet.AddAsync(entity);
    public async Task CreateRangeAsync(IEnumerable<T> entities) => await _dbSet.AddRangeAsync(entities);

    public async Task<int> CountAsync(BaseSpecification<T> spec) =>
      await SpecificationEvaluator<T>
          .GetQuery(_dbSet, spec)
          .CountAsync();

    public void Delete(T entity) => _dbSet.Remove(entity);

    public async Task<bool> AnyAsync(Expression<Func<T, bool>> predicate) => await _dbSet.AnyAsync(predicate);

  }
}
