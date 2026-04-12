using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.Repositories;

public interface IHallRepository : IRepository<Hall>
{
  public void Update(Hall hall);
}
