using System.Linq.Expressions;

namespace Ticketa.Core.Interfaces.Repositories
{
  public interface IRepository<T> where T : class
  {
    Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>>? filter = null, params string[] includes);
    Task<T?> GetAsync(Expression<Func<T, bool>> filter, params string[] includes);
    Task CreateAsync(T entity);
    void Delete(T entity);
    Task<bool> AnyAsync(Expression<Func<T, bool>> predicate);
  }
}
