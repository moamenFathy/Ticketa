namespace Ticketa.Core.Interfaces
{
  public interface IUnitOfWork : IDisposable
  {
    Task SaveAsync();
  }
}
