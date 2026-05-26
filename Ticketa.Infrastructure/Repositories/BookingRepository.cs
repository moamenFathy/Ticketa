using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Core.Specifications;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class BookingRepository(ApplicationDbContext context) : GenericRepository<Booking>(context), IBookingRepository
  {
    public async Task<Booking?> GetBookingByRefrenceAsync(string reference, CancellationToken ct = default)
    {
      var spec = new BookingByRefrenceSpecification(reference);
      return await GetEntityWithSpecAsync(spec);
    }
  }
}
