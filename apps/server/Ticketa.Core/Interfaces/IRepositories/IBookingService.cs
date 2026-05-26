using Ticketa.Core.DTOs;

namespace Ticketa.Core.Interfaces.IRepositories
{
  public interface IBookingService
  {
    Task<BookingResultDto> CreateAsync(BookingCreateDto dto, string userId, CancellationToken ct = default);
  }
}
