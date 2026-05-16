using Ticketa.Core.Interfaces.IRepositories;

namespace Ticketa.Core.Interfaces
{
  public interface IUnitOfWork : IDisposable
  {
    IHallRepository Halls { get; }
    IMovieRepository Movies { get; }
    IGenreRepository Genres { get; }
    IShowtimeRepository Showtimes { get; }
    IBookedSeatRepository BookedSeats { get; }
    Task SaveAsync();
  }
}
