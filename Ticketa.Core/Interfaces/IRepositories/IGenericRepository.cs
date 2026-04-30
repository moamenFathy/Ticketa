using System.Linq.Expressions;
using Ticketa.Core.Specifications;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IGenericRepository<T> where T : class
  {
    Task<IEnumerable<T>> GetAllAsync();
    Task<T?> GetAsync(Expression<Func<T, bool>> filter);
    Task CreateAsync(T entity);
    Task CreateRangeAsync(IEnumerable<T> entities);
    Task<int> CountAsync(BaseSpecification<T> spec);
    void Delete(T entity);
    Task<bool> AnyAsync(Expression<Func<T, bool>> predicate);
    Task<IReadOnlyList<T>> GetAllWithSpecAsync(BaseSpecification<T> spec);
  }
}
