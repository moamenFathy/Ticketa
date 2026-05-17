using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IRepositories;

public interface IHallRepository : IGenericRepository<Hall>
{
  public void Update(Hall hall);
}
