using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IBookedSeatRepository : IGenericRepository<BookedSeat>
  {
    Task<IEnumerable<BookedSeat>> GetByShowtimeIdAsync(int showtimeId, CancellationToken ct = default);
    Task<IEnumerable<BookedSeat>> GetConflictAsync(int showtimeId, IEnumerable<SeatSelectionDto> seats, CancellationToken ct = default);
    Task AddRange(IEnumerable<BookedSeat> seats);
  }
}
