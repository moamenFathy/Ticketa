using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class UnitOfWork(ApplicationDbContext context) : IUnitOfWork
  {
    private readonly ApplicationDbContext _context = context;
    private IHallRepository? _halls;
    private IMovieRepository? _movies;
    private IGenreRepository? _genres;
    private IShowtimeRepository? _showtimes;
    private IBookingRepository? _bookings;
    private IBookedSeatRepository? _bookedseat;
    private IPaymentRepository? _payments;

    public IHallRepository Halls => _halls ??= new HallRepository(_context);

    public IMovieRepository Movies => _movies ??= new MovieRepository(_context);

    public IGenreRepository Genres => _genres ??= new GenreRepository(_context);

    public IShowtimeRepository Showtimes => _showtimes ??= new ShowtimeRepository(_context);

    public IBookingRepository Bookings => _bookings ??= new BookingRepository(_context);

    public IBookedSeatRepository BookedSeats => _bookedseat ??= new BookedSeatRepository(_context);

    public IPaymentRepository Payments => _payments ??= new PaymentRepository(_context);

    public async Task SaveAsync()
    {
      await _context.SaveChangesAsync();
    }

    public void Dispose()
    {
      _context.Dispose();
    }
  }
}
