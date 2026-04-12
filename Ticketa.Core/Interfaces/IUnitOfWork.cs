using Ticketa.Core.Interfaces.Repositories;

namespace Ticketa.Core.Interfaces
{
  public interface IUnitOfWork : IDisposable
  {
    IHallRepository Halls { get; }
    Task SaveAsync();
  }
}
