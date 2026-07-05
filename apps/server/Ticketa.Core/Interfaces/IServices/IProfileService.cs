using Ticketa.Core.DTOs.Common;
using Ticketa.Core.DTOs.Profile;

namespace Ticketa.Core.Interfaces.IServices
{
  public interface IProfileService
  {
    Task<ProfileDto?> GetProfileAsync(string userId, CancellationToken ct = default);
    Task<(bool Success, IEnumerable<string> Errors)> UpdateProfileAsync(string userId, ProfileUpdateDto dto, CancellationToken ct = default);
    Task<(bool Success, IEnumerable<string> Errors)> ChangePasswordAsync(string userId, ChangePasswordDto dto, CancellationToken ct = default);
    Task<PagedResultDto<BookingHistoryItemDto>> GetBookingHistoryAsync(string userId, int page, int pageSize, CancellationToken ct = default);
  }
}
