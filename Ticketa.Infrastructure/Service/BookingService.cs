using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Helpers;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Service
{
  public class BookingService(IUnitOfWork uow, ILogger<BookingService> logger) : IBookingService
  {
    private readonly IUnitOfWork _uow = uow;
    private readonly ILogger<BookingService> _logger = logger;

    public async Task<BookingResultDto> CreateAsync(BookingCreateDto dto, string userId, CancellationToken ct = default)
    {
      _logger.LogInformation("Booking attempt: ShowtimeId={ShowtimeId}, Seats={Seats}, UserId={UserId}",
        dto.ShowtimeId, dto.Seats.Select(s => $"R{s.Row}S{s.SeatNumber}"), userId);

      var spec = new ShowtimeByIdSpecification(dto.ShowtimeId);
      var showtime = await _uow.Showtimes.GetEntityWithSpecAsync(spec, ct);

      if (showtime is null)
      {
        _logger.LogWarning("Booking conflict: ShowtimeId={ShowtimeId} not found", dto.ShowtimeId);
        return BookingResultDto.Conflict([]);
      }

      var conflict = (await _uow.BookedSeats.GetConflictAsync(dto.ShowtimeId, dto.Seats, ct)).ToList();

      if (conflict.Count > 0)
      {
        _logger.LogWarning("Booking conflict: seats already booked. Conflicts={Conflicts}",
          conflict.Select(c => $"R{c.Row}S{c.SeatNumber}"));
        return BookingResultDto.Conflict(conflict.Select(c => new SeatDto { Row = c.Row, SeatNumber = c.SeatNumber }).ToList());
      }

      var template = HallTypeHelper.GetTemplate(showtime.Hall.Type);

      var bookedSeats = dto.Seats.Select(s =>
      {
        var category = template.RowCategoryMap[s.Row];
        decimal multiplier = HallTypeHelper.GetPriceMultiplier(category);

        return new BookedSeat
        {
          ShowtimeId = dto.ShowtimeId,
          Row = s.Row,
          SeatNumber = s.SeatNumber,
          Category = category,
          Price = showtime.Price * multiplier
        };
      }).ToList();

      var booking = new Booking
      {
        UserId = userId,
        ShowtimeId = dto.ShowtimeId,
        BookedAt = DateTime.UtcNow,
        TotalAmount = bookedSeats.Sum(s => s.Price),
        Status = Core.Enums.BookingStatus.Confirmed,
        BookingRefrence = GenerateRefrence(),
        BookedSeats = bookedSeats
      };

      await _uow.Bookings.CreateAsync(booking);

      var existingBookedCount = await _uow.BookedSeats.CountAsync(
          new BookedSeatByShowtimeIdSpecification(dto.ShowtimeId));
      var totalSeats = template.VisibleSeatCount;

      if (existingBookedCount + dto.Seats.Count >= totalSeats)
      {
        showtime.Status = ShowtimeStatus.SoldOut;
        await _uow.Showtimes.UpdateAsync(showtime);
      }

      try
      {
        await _uow.SaveAsync();
      }
      catch (DbUpdateException ex)
      {
        _logger.LogWarning(ex, "Booking save conflict");
        var lateConflict = await _uow.BookedSeats
          .GetConflictAsync(dto.ShowtimeId, dto.Seats, ct);

        return BookingResultDto.Conflict(lateConflict.Select(c => new SeatDto { Row = c.Row, SeatNumber = c.SeatNumber }).ToList());
      }

      _logger.LogInformation("Booking successful: Reference={Ref}", booking.BookingRefrence);
      return BookingResultDto.Success(booking.BookingRefrence, booking.TotalAmount);
    }
    public async Task<BookingDetailsDto?> GetByReferenceAsync(string reference, CancellationToken ct = default)
    {
      var booking = await _uow.Bookings.GetBookingByRefrenceAsync(reference, ct);
      return booking is null ? null : new BookingDetailsDto
      {
        UserId = booking.UserId,
        UserEmail = booking.User.UserName!,
        BookingRefrence = booking.BookingRefrence,
        Status = booking.Status,
        BookedAt = booking.BookedAt,
        TotalAmount = booking.TotalAmount,
        MovieTitle = booking.Showtime.Movie.Title,
        MoviePosterPath = booking.Showtime.Movie.PosterPath,
        StartsAt = booking.Showtime.StartTime,
        HallName = booking.Showtime.Hall.Name,
        HallType = booking.Showtime.Hall.Type.ToString(),
        Seats = booking.BookedSeats.Select(s => new BookingDetailsSeatDto
        {
          Row = s.Row,
          SeatNumber = s.SeatNumber,
          Category = s.Category.ToString(),
          Price = s.Price
        }).ToList(),
      };
    }

    public async Task<(bool Success, string Message)> CancelBookingsForPaymentAsync(int showtimeId, IEnumerable<PaymentSeat> paymentSeats)
    {
      var showtimeSpec = new ShowtimeByIdSpecification(showtimeId);
      var showtime = await _uow.Showtimes.GetEntityWithSpecAsync(showtimeSpec);

      if (showtime is null)
        return (false, "Showtime not found.");

      var paymentSeatList = paymentSeats.ToList();
      if (paymentSeatList.Count == 0)
        return (false, "No seats associated with this payment.");

      var seatPairs = paymentSeatList.Select(s => (s.Row, s.SeatNumber)).ToList();

      var allBookedSeats = (await _uow.BookedSeats.GetByShowtimeIdAsync(showtimeId)).ToList();

      var matchedSeats = allBookedSeats
          .Where(bs => seatPairs.Any(sp => sp.Row == bs.Row && sp.SeatNumber == bs.SeatNumber))
          .ToList();

      if (matchedSeats.Count == 0)
        return (false, "No matching booked seats found for this payment.");

      var matchedBookingIds = matchedSeats.Select(s => s.BookingId).Distinct().ToList();
      var bookings = new List<Booking>();
      foreach (var id in matchedBookingIds)
      {
        var b = await _uow.Bookings.GetAsync(b => b.Id == id);
        if (b is not null) bookings.Add(b);
      }

      foreach (var seat in matchedSeats)
      {
        _uow.BookedSeats.Delete(seat);
      }

      foreach (var booking in bookings)
      {
        var remainingForBooking = allBookedSeats
            .Count(bs => bs.BookingId == booking.Id && !matchedSeats.Contains(bs));
        if (remainingForBooking == 0)
        {
          booking.Status = BookingStatus.Cancelled;
        }
      }

      await _uow.SaveAsync();

      if (showtime.Status == ShowtimeStatus.SoldOut)
      {
        var template = HallTypeHelper.GetTemplate(showtime.Hall.Type);
        var remainingSeatsCount = await _uow.BookedSeats.CountAsync(
            new BookedSeatByShowtimeIdSpecification(showtimeId));

        if (remainingSeatsCount < template.VisibleSeatCount)
        {
          showtime.Status = ShowtimeStatus.Scheduled;
        }

        await _uow.SaveAsync();
      }

      return (true, "Bookings cancelled successfully.");
    }

    private static string GenerateRefrence() => $"TKT-{DateTime.UtcNow:yyyyMMdd}-{Random.Shared.Next(1000, 9999)}";

  }
}
