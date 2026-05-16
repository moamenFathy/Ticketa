using Microsoft.EntityFrameworkCore;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class BookedSeatRepository(ApplicationDbContext context) : GenericRepository<BookedSeat>(context), IBookedSeatRepository
  {
    public async Task<IEnumerable<BookedSeat>> GetByShowtimeIdAsync(int showtimeId, CancellationToken ct = default)
      => await _context.BookedSeats.Where(s => s.ShowtimeId == showtimeId).ToListAsync(ct);

    public async Task<IEnumerable<BookedSeat>> GetConflictAsync(int showtimeId, IEnumerable<SeatSelectionDto> seats, CancellationToken ct = default)
    {
      var rowNumbers = seats.Select(s => s.Row).ToList();
      var seatNumbers = seats.Select(s => s.SeatNumber).ToList();

      var candidates = await _context.BookedSeats
        .Where(s => s.ShowtimeId == showtimeId
                && rowNumbers.Contains(s.Row)
                && seatNumbers.Contains(s.SeatNumber))
        .ToListAsync(ct);

      return candidates.Where(s =>
        seats.Any(r => r.Row == s.Row && r.SeatNumber == s.SeatNumber));
    }

    public async Task AddRange(IEnumerable<BookedSeat> seats) => await _context.BookedSeats.AddRangeAsync(seats);
  }
}
