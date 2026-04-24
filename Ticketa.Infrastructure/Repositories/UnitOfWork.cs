using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories
{
  public class UnitOfWork : IUnitOfWork
  {
    private readonly ApplicationDbContext _context;
    private IHallRepository? _halls;
    private IMovieRepository? _movies;
    private IGenreRepository? _genres;
    private IShowtimeRepository? _showtimes;

    public UnitOfWork(ApplicationDbContext context)
    {
      _context = context;
    }

    public IHallRepository Halls => _halls ??= new HallRepository(_context);

    public IMovieRepository Movies => _movies ??= new MovieRepository(_context);

    public IGenreRepository Genres => _genres ??= new GenreRepository(_context);

    public IShowtimeRepository Showtimes => _showtimes ??= new ShowtimeRepository(_context);

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
