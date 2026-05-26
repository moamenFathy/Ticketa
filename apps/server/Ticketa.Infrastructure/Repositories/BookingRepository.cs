using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class BookingRepository(ApplicationDbContext context) : GenericRepository<Booking>(context), IBookingRepository
  {
  }
}
