using System.Linq.Expressions;
using AutoMapper;
using Microsoft.Extensions.Configuration;
using Moq;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Helpers;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Core.Interfaces.Services;
using Ticketa.Infrastructure.Service;
using Xunit;

namespace Ticketa.Tests.Infrastructure.Services
{
  public class MoviesServiceTests
  {
    private readonly Mock<IUnitOfWork> _mockUow;
    private readonly Mock<IMovieRepository> _mockMovieRepo;
    private readonly Mock<IShowtimeRepository> _mockShowtimeRepo;
    private readonly Mock<ITmdbService> _mockTmdbService;
    private readonly Mock<IMapper> _mockMapper;
    private readonly TimeConversions _timeConversions;
    private readonly MoviesService _sut;

    private const int DefaultMovieId = 1;

    public MoviesServiceTests()
    {
      _mockUow = new Mock<IUnitOfWork>();
      _mockMovieRepo = new Mock<IMovieRepository>();
      _mockShowtimeRepo = new Mock<IShowtimeRepository>();
      _mockTmdbService = new Mock<ITmdbService>();
      _mockMapper = new Mock<IMapper>();

      _mockUow.Setup(u => u.Movies).Returns(_mockMovieRepo.Object);
      _mockUow.Setup(u => u.Showtimes).Returns(_mockShowtimeRepo.Object);

      var configuration = new ConfigurationBuilder()
          .AddInMemoryCollection(new Dictionary<string, string?> { { "AppTimeZone", "UTC" } })
          .Build();
      _timeConversions = new TimeConversions(configuration);

      _sut = new MoviesService(_mockUow.Object, _mockTmdbService.Object, _mockMapper.Object, _timeConversions);
    }

    #region UpdateStatusAsync & Archiving Tests

    [Fact]
    public async Task UpdateStatusAsync_WhenStatusSetToArchived_SetsIsArchivedTrueAndArchivedAt()
    {
      // Arrange
      var movie = new Movie
      {
        Id = DefaultMovieId,
        Title = "Inception",
        Status = MovieStatus.Active,
        IsArchived = false,
        ArchivedAt = null
      };

      _mockMovieRepo
          .Setup(r => r.GetAsync(It.IsAny<Expression<Func<Movie, bool>>>()))
          .ReturnsAsync(movie);

      // Act
      var result = await _sut.UpdateStatusAsync(DefaultMovieId, MovieStatus.Archived);

      // Assert
      Assert.True(result);
      Assert.Equal(MovieStatus.Archived, movie.Status);
      Assert.True(movie.IsArchived);
      Assert.NotNull(movie.ArchivedAt);

      _mockMovieRepo.Verify(r => r.UpdateAsync(movie), Times.Once);
      _mockUow.Verify(u => u.SaveAsync(), Times.Once);
    }

    [Fact]
    public async Task UpdateStatusAsync_WhenStatusSetToActive_ResetsIsArchivedFalseAndClearsArchivedAt()
    {
      // Arrange: Reactivating an archived movie
      var movie = new Movie
      {
        Id = DefaultMovieId,
        Title = "Inception",
        Status = MovieStatus.Archived,
        IsArchived = true,
        ArchivedAt = DateTime.UtcNow.AddDays(-10)
      };

      _mockMovieRepo
          .Setup(r => r.GetAsync(It.IsAny<Expression<Func<Movie, bool>>>()))
          .ReturnsAsync(movie);

      // Act
      var result = await _sut.UpdateStatusAsync(DefaultMovieId, MovieStatus.Active);

      // Assert
      Assert.True(result);
      Assert.Equal(MovieStatus.Active, movie.Status);
      Assert.False(movie.IsArchived);
      Assert.Null(movie.ArchivedAt);

      _mockMovieRepo.Verify(r => r.UpdateAsync(movie), Times.Once);
      _mockUow.Verify(u => u.SaveAsync(), Times.Once);
    }

    [Fact]
    public async Task UpdateStatusAsync_WhenMovieNotFound_ReturnsFalse()
    {
      // Arrange
      _mockMovieRepo
          .Setup(r => r.GetAsync(It.IsAny<Expression<Func<Movie, bool>>>()))
          .ReturnsAsync((Movie?)null);

      // Act
      var result = await _sut.UpdateStatusAsync(999, MovieStatus.Archived);

      // Assert
      Assert.False(result);
      _mockMovieRepo.Verify(r => r.UpdateAsync(It.IsAny<Movie>()), Times.Never);
      _mockUow.Verify(u => u.SaveAsync(), Times.Never);
    }

    #endregion

    #region DeleteAsync Tests

    [Fact]
    public async Task DeleteAsync_WhenMovieNotFound_ReturnsMovieNotFoundError()
    {
      // Arrange
      _mockMovieRepo
          .Setup(r => r.GetAsync(It.IsAny<Expression<Func<Movie, bool>>>()))
          .ReturnsAsync((Movie?)null);

      // Act
      var error = await _sut.DeleteAsync(DefaultMovieId);

      // Assert
      Assert.Equal("Movie not found.", error);
      _mockMovieRepo.Verify(r => r.Delete(It.IsAny<Movie>()), Times.Never);
      _mockUow.Verify(u => u.SaveAsync(), Times.Never);
    }

    [Fact]
    public async Task DeleteAsync_WhenMovieHasAssociatedShowtimes_BlocksDeletion()
    {
      // Arrange: Deletion safety check
      var movie = new Movie { Id = DefaultMovieId, Title = "Avatar" };
      _mockMovieRepo
          .Setup(r => r.GetAsync(It.IsAny<Expression<Func<Movie, bool>>>()))
          .ReturnsAsync(movie);

      _mockShowtimeRepo
          .Setup(r => r.AnyAsync(It.IsAny<Expression<Func<Showtime, bool>>>()))
          .ReturnsAsync(true); // Has showtimes!

      // Act
      var error = await _sut.DeleteAsync(DefaultMovieId);

      // Assert
      Assert.Equal("Can't remove this movie — it still has showtimes.", error);
      _mockMovieRepo.Verify(r => r.Delete(It.IsAny<Movie>()), Times.Never);
      _mockUow.Verify(u => u.SaveAsync(), Times.Never);
    }

    [Fact]
    public async Task DeleteAsync_WhenMovieHasZeroShowtimes_DeletesMovieAndSaves()
    {
      // Arrange
      var movie = new Movie { Id = DefaultMovieId, Title = "Avatar" };
      _mockMovieRepo
          .Setup(r => r.GetAsync(It.IsAny<Expression<Func<Movie, bool>>>()))
          .ReturnsAsync(movie);

      _mockShowtimeRepo
          .Setup(r => r.AnyAsync(It.IsAny<Expression<Func<Showtime, bool>>>()))
          .ReturnsAsync(false); // Zero showtimes

      // Act
      var error = await _sut.DeleteAsync(DefaultMovieId);

      // Assert
      Assert.Null(error);
      _mockMovieRepo.Verify(r => r.Delete(movie), Times.Once);
      _mockUow.Verify(u => u.SaveAsync(), Times.Once);
    }

    #endregion
  }
}
