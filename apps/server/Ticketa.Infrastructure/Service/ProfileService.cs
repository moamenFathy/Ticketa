using Microsoft.AspNetCore.Identity;
using Ticketa.Core.DTOs.Common;
using Ticketa.Core.DTOs.Profile;
using Ticketa.Core.Entities;
using Ticketa.Core.Helpers;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Specification;

namespace Ticketa.Infrastructure.Service
{
  public class ProfileService(UserManager<AppUser> userManager, IUnitOfWork uow, TimeConversions timeConversions) : IProfileService
  {
    private readonly UserManager<AppUser> _userManager = userManager;
    private readonly IUnitOfWork _uow = uow;

    public async Task<ProfileDto?> GetProfileAsync(string userId, CancellationToken ct = default)
    {
      var user = await _userManager.FindByIdAsync(userId);
      if (user is null) return null;

      return new ProfileDto
      {
        FirstName = user.FirstName,
        LastName = user.LastName,
        Email = user.Email ?? "",
        DateOfBirth = user.DateOfBirth,
        Theme = user.Theme
      };
    }

    public async Task<(bool Success, IEnumerable<string> Errors)> UpdateProfileAsync(
        string userId, ProfileUpdateDto dto, CancellationToken ct = default)
    {
      var user = await _userManager.FindByIdAsync(userId);
      if (user is null) return (false, ["User not found."]);

      user.FirstName = dto.FirstName;
      user.LastName = dto.LastName;
      user.DateOfBirth = dto.DateOfBirth;
      user.Theme = dto.Theme;

      var result = await _userManager.UpdateAsync(user);
      return result.Succeeded
        ? (true, [])
        : (false, result.Errors.Select(e => e.Description));
    }

    public async Task<(bool Success, IEnumerable<string> Errors)> ChangePasswordAsync(
        string userId, ChangePasswordDto dto, CancellationToken ct = default)
    {
      var user = await _userManager.FindByIdAsync(userId);
      if (user is null) return (false, ["User not found."]);

      var result = await _userManager.ChangePasswordAsync(
          user, dto.CurrentPassword, dto.NewPassword);

      return result.Succeeded
        ? (true, [])
        : (false, result.Errors.Select(e => e.Description));
    }

    public async Task<PagedResultDto<BookingHistoryItemDto>> GetBookingHistoryAsync(
        string userId, int page, int pageSize, CancellationToken ct = default)
    {
      pageSize = Math.Min(pageSize, 25);

      var totalCount = await _uow.Bookings.CountAsync(
          new BookingHistoryCountSpecification(userId));

      var items = await _uow.Bookings.GetAllWithSpecAsync(
          new BookingHistorySpecification(userId, page, pageSize), ct);

      return new PagedResultDto<BookingHistoryItemDto>
      {
        Items = items.Select(b => new BookingHistoryItemDto
        {
          BookingReference = b.BookingRefrence,
          MovieTitle = b.Showtime.Movie.Title,
          MoviePosterPath = b.Showtime.Movie.PosterPath,
          ShowtimeStartsAt = timeConversions.EnsureUtcKind(b.Showtime.StartTime),
          SeatCount = b.BookedSeats.Count,
          TotalAmount = b.TotalAmount,
          Status = b.Status
        }),
        Page = page,
        PageSize = pageSize,
        TotalCount = totalCount,
        HasMore = (page * pageSize) < totalCount
      };
    }
  }
}
