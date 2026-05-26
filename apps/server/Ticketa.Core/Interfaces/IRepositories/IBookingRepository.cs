using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IBookingRepository : IGenericRepository<Booking>
  {
    Task<Booking?> GetBookingByRefrenceAsync(string reference, CancellationToken ct = default);
  }
}
