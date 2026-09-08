using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Moq;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Helpers;
using Ticketa.Infrastructure.Data;
using Ticketa.Infrastructure.Repositories;
using Ticketa.Infrastructure.Service;
using Xunit;

namespace Ticketa.Tests.Integration
{
  public class BookingConcurrencyIntegrationTests : IAsyncLifetime
  {
    private readonly string _databaseName;
    private readonly string _connectionString;
    private readonly DbContextOptions<ApplicationDbContext> _dbOptions;
    private readonly TimeConversions _timeConversions;
    private int _seededShowtimeId;

    public BookingConcurrencyIntegrationTests()
    {
      _databaseName = $"Ticketa_Concurrency_{Guid.NewGuid():N}";
      _connectionString = $"Server=(localdb)\\mssqllocaldb;Database={_databaseName};Trusted_Connection=True;MultipleActiveResultSets=true";

      _dbOptions = new DbContextOptionsBuilder<ApplicationDbContext>()
          .UseSqlServer(_connectionString)
          .Options;

      var inMemoryConfig = new Dictionary<string, string?> { { "AppTimeZone", "UTC" } };
      var configuration = new ConfigurationBuilder().AddInMemoryCollection(inMemoryConfig).Build();
      _timeConversions = new TimeConversions(configuration);
    }

    public async Task InitializeAsync()
    {
      await using var context = new ApplicationDbContext(_dbOptions);
      await context.Database.EnsureCreatedAsync();

      // Seed users for foreign key constraint
      var userAlice = new AppUser { Id = "user-alice", UserName = "alice@example.com", Email = "alice@example.com" };
      var userBob = new AppUser { Id = "user-bob", UserName = "bob@example.com", Email = "bob@example.com" };
      context.Users.AddRange(userAlice, userBob);

      // Seed baseline entities
      var movie = new Movie
      {
        Title = "Oppenheimer",
        RuntimeMinutes = 180,
        Status = MovieStatus.Active,
        IsArchived = false
      };
      context.Movies.Add(movie);

      var hall = new Hall
      {
        Name = "Grand IMAX",
        Type = HallType.Standard,
        TotalRows = 12,
        SeatsPerRow = 16
      };
      context.Halls.Add(hall);
      await context.SaveChangesAsync();

      var showtime = new Showtime
      {
        MovieId = movie.Id,
        HallId = hall.Id,
        StartTime = DateTime.UtcNow.AddHours(6),
        EndTime = DateTime.UtcNow.AddHours(9).AddMinutes(15),
        Price = 100m,
        Status = ShowtimeStatus.Scheduled,
        IsArchived = false
      };
      context.Showtimes.Add(showtime);
      await context.SaveChangesAsync();

      _seededShowtimeId = showtime.Id;
    }

    public async Task DisposeAsync()
    {
      await using var context = new ApplicationDbContext(_dbOptions);
      await context.Database.EnsureDeletedAsync();
    }

    [Fact]
    public async Task CreateAsync_WhenTwoUsersConcurrentlyBookExactSameSeat_RealSqlServerEnforcesUniqueConstraint()
    {
      // Arrange: Two independent database contexts representing two simultaneous HTTP connections
      await using var contextUserA = new ApplicationDbContext(_dbOptions);
      await using var contextUserB = new ApplicationDbContext(_dbOptions);

      var uowA = new UnitOfWork(contextUserA);
      var uowB = new UnitOfWork(contextUserB);

      var logger = Mock.Of<ILogger<BookingService>>();

      var serviceA = new BookingService(uowA, logger, _timeConversions);
      var serviceB = new BookingService(uowB, logger, _timeConversions);

      var bookingDto = new BookingCreateDto
      {
        ShowtimeId = _seededShowtimeId,
        Seats = [new SeatDto { Row = 1, SeatNumber = 1 }] // Contested seat: (Row: 1, Seat: 1)
      };

      // Act: Fire both requests in parallel against real Microsoft SQL Server engine
      var taskA = serviceA.CreateAsync(bookingDto, "user-alice");
      var taskB = serviceB.CreateAsync(bookingDto, "user-bob");

      var results = await Task.WhenAll(taskA, taskB);
      var resultA = results[0];
      var resultB = results[1];

      // Assert: Exactly ONE user must succeed, and exactly ONE user must get a conflict
      var successfulResults = results.Where(r => r.Succeeded).ToList();
      var conflictResults = results.Where(r => !r.Succeeded).ToList();

      Assert.Single(successfulResults);
      Assert.Single(conflictResults);

      var conflictResult = conflictResults[0];
      Assert.NotEmpty(conflictResult.ConflictingSeats);
      Assert.Equal(1, conflictResult.ConflictingSeats[0].Row);
      Assert.Equal(1, conflictResult.ConflictingSeats[0].SeatNumber);

      // Verify the real SQL Server database contains EXACTLY 1 BookedSeat record (Zero Double-Booking)
      await using var verifyContext = new ApplicationDbContext(_dbOptions);
      var bookedSeatsInDb = await verifyContext.BookedSeats
          .Where(s => s.ShowtimeId == _seededShowtimeId && s.Row == 1 && s.SeatNumber == 1)
          .ToListAsync();

      Assert.Single(bookedSeatsInDb);
      Assert.Equal(100m, bookedSeatsInDb[0].Price);
    }

    [Fact]
    public async Task CreateAsync_WhenTwoUsersBookDifferentSeatsSimultaneously_BothSucceedInRealSqlServer()
    {
      // Arrange
      await using var contextUserA = new ApplicationDbContext(_dbOptions);
      await using var contextUserB = new ApplicationDbContext(_dbOptions);

      var uowA = new UnitOfWork(contextUserA);
      var uowB = new UnitOfWork(contextUserB);

      var logger = Mock.Of<ILogger<BookingService>>();

      var serviceA = new BookingService(uowA, logger, _timeConversions);
      var serviceB = new BookingService(uowB, logger, _timeConversions);

      var dtoA = new BookingCreateDto
      {
        ShowtimeId = _seededShowtimeId,
        Seats = [new SeatDto { Row = 1, SeatNumber = 1 }]
      };

      var dtoB = new BookingCreateDto
      {
        ShowtimeId = _seededShowtimeId,
        Seats = [new SeatDto { Row = 1, SeatNumber = 2 }]
      };

      // Act: Fire both distinct seat bookings concurrently
      var taskA = serviceA.CreateAsync(dtoA, "user-alice");
      var taskB = serviceB.CreateAsync(dtoB, "user-bob");

      var results = await Task.WhenAll(taskA, taskB);

      // Assert: Both must succeed without conflict
      Assert.True(results[0].Succeeded);
      Assert.True(results[1].Succeeded);

      // Verify both seats exist in SQL Server
      await using var verifyContext = new ApplicationDbContext(_dbOptions);
      var bookedSeatsCount = await verifyContext.BookedSeats
          .Where(s => s.ShowtimeId == _seededShowtimeId)
          .CountAsync();

      Assert.Equal(2, bookedSeatsCount);
    }

    [Fact]
    public async Task CreateAsync_WhenConcurrencyReachesCapacity_RealSqlServerTransitionsShowtimeToSoldOut()
    {
      // Arrange: Seed a Gold Hall (38 visible seats) with 36 existing booked seats
      await using var setupContext = new ApplicationDbContext(_dbOptions);

      var goldHall = new Hall { Name = "Gold Lounge", Type = HallType.Gold, TotalRows = 6, SeatsPerRow = 8 };
      setupContext.Halls.Add(goldHall);
      await setupContext.SaveChangesAsync();

      var goldShowtime = new Showtime
      {
        MovieId = 1,
        HallId = goldHall.Id,
        StartTime = DateTime.UtcNow.AddHours(6),
        EndTime = DateTime.UtcNow.AddHours(8),
        Price = 200m,
        Status = ShowtimeStatus.Scheduled,
        IsArchived = false
      };
      setupContext.Showtimes.Add(goldShowtime);
      await setupContext.SaveChangesAsync();

      var seedBooking = new Booking
      {
        UserId = "user-alice",
        ShowtimeId = goldShowtime.Id,
        BookedAt = DateTime.UtcNow,
        TotalAmount = 7200m,
        Status = BookingStatus.Confirmed,
        BookingRefrence = "TKT-PRE-SEEDED"
      };
      setupContext.Bookings.Add(seedBooking);

      // Seed 37 seats (leaving exactly 1 seat available in the 38-seat hall)
      var preBookedSeats = new List<BookedSeat>();
      for (int i = 1; i <= 37; i++)
      {
        preBookedSeats.Add(new BookedSeat
        {
          Booking = seedBooking,
          ShowtimeId = goldShowtime.Id,
          Row = 2 + (i / 10),
          SeatNumber = (i % 10) + 1,
          Category = SeatCategory.Regular,
          Price = 200m
        });
      }
      setupContext.BookedSeats.AddRange(preBookedSeats);
      await setupContext.SaveChangesAsync();

      // User A books the 38th (last) seat
      await using var contextA = new ApplicationDbContext(_dbOptions);
      var serviceA = new BookingService(new UnitOfWork(contextA), Mock.Of<ILogger<BookingService>>(), _timeConversions);

      var dtoA = new BookingCreateDto
      {
        ShowtimeId = goldShowtime.Id,
        Seats = [new SeatDto { Row = 1, SeatNumber = 4 }]
      };

      // Act
      var result = await serviceA.CreateAsync(dtoA, "user-alice");

      // Assert: The booking succeeds and the showtime is marked SoldOut in SQL Server
      Assert.True(result.Succeeded);

      await using var verifyContext = new ApplicationDbContext(_dbOptions);
      var updatedShowtime = await verifyContext.Showtimes.FindAsync(goldShowtime.Id);

      Assert.NotNull(updatedShowtime);
      Assert.Equal(ShowtimeStatus.SoldOut, updatedShowtime.Status);
    }
  }
}
