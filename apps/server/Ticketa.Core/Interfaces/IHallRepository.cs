using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces;

public interface IHallRepository : IRepository<Hall>
{
  public void Update(Hall hall);
}
