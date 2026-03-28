using System.Linq.Expressions;

namespace Ticketa.Core.Interfaces
{
  public interface IRepository<T> where T : class
  {
    Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>>? filter);
    Task<T?> GetByIdAsync(int id);
    Task CreateAsync(T entity);
    void Delete(T entity);
  }
}
