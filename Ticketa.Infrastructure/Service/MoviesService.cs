using AutoMapper;
using Ticketa.Core.DTOs;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Interfaces.Services;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Service
{
  public class MoviesService : IMoviesService
  {
    private readonly IUnitOfWork _uow;
    private readonly ITmdbService _tmdbService;
    private readonly IMapper _mapper;

    public MoviesService(IUnitOfWork uow, ITmdbService tmdbService, IMapper mapper)
    {
      _uow = uow;
      _tmdbService = tmdbService;
      _mapper = mapper;
    }

    public async Task<bool> DeleteAsync(int id)
    {
      var movie = await _uow.Movies.GetAsync(m => m.Id == id);

      if (movie is null)
        return false;

      if (await _uow.Showtimes.AnyAsync(s => s.MovieId == id))
        return false; // Prevention logic

      _uow.Movies.Delete(movie);
      await _uow.SaveAsync();

      return true;
    }

    public async Task<object> GetAllAsync(
        DataTableRequestsDto request,
        string? search,
        int orderColumn,
        string orderDir,
        string? segmentedFilter)
    {
      var status = MapStatus(segmentedFilter);
      var searchValue = string.IsNullOrWhiteSpace(search) ? null : search;

      // 1. Total count (no filters)
      var totalSpec = new MovieSpecification();
      var total = await _uow.Movies.CountAsync(totalSpec);

      // 2. Filtered count
      var countSpec = new MovieSpecification(status, searchValue);
      var filtered = await _uow.Movies.CountAsync(countSpec);

      // 3. Data with paging
      var spec = new MovieSpecification(
          status,
          searchValue,
          orderColumn,
          orderDir,
          request.Start,
          request.Length);

      var movies = await _uow.Movies.GetAllWithSpecAsync(spec);

      var dataList = new List<object>();
      foreach (var m in movies)
      {
        bool hasShowtimes = await _uow.Showtimes.AnyAsync(s => s.MovieId == m.Id);
        dataList.Add(new
        {
          m.Id,
          m.Title,
          m.Status,
          m.PosterPath,
          m.Overview,
          m.ReleaseDate,
          m.VoteAverage,
          m.ImportedAt,
          m.RuntimeMinutes,
          m.TmdbId,
          m.TrailerKey,
          hasShowtimes
        });
      }

      // 4. DataTables response
      return new
      {
        draw = request.Draw,
        recordsTotal = total,
        recordsFiltered = filtered,
        data = dataList
      };
    }

    public async Task<Movie?> GetByIdAsync(int id)
    {
      return await _uow.Movies.GetAsync(m => m.Id == id);
    }

    public async Task<MovieImportResultDto> ImportMoviesAsync(List<int> tmdbIds, CancellationToken cancellationToken)
    {
      var result = new MovieImportResultDto();

      var selectedIds = tmdbIds.Distinct().ToList();
      var existingIds = await _uow.Movies.ExistingTmdbIdsAsync(selectedIds);
      var idsToImport = selectedIds.Where(id => !existingIds.Contains(id)).ToList();

      var movieGenrePairs = new List<(Movie Movie, List<TmdbGenreDto> Genres)>();

      foreach (var tmdbId in idsToImport)
      {
        var movieDetails = await _tmdbService.GetMovieDetailAsync(tmdbId, cancellationToken);

        if (movieDetails == null || movieDetails.TmdbId == 0)
        {
          result.FailedCount++;
          continue;
        }

        var movie = _mapper.Map<Movie>(movieDetails);
        movie.TrailerKey = await _tmdbService.GetTrailerKeyAsync(tmdbId, cancellationToken);
        movie.RuntimeMinutes = movieDetails.Runtime;

        movieGenrePairs.Add((movie, movieDetails.Genres));
      }

      if (movieGenrePairs.Any())
      {
        var allGenreDtos = movieGenrePairs
            .SelectMany(p => p.Genres)
            .DistinctBy(g => g.Id)
            .ToList();

        var existingGenres = await _uow.Genres.GetByTmdbIdsAsync(allGenreDtos.Select(g => g.Id));
        var genreMap = existingGenres.ToDictionary(g => g.TmdbId);

        var newGenres = allGenreDtos
            .Where(g => !genreMap.ContainsKey(g.Id))
            .Select(g => new Genre { TmdbId = g.Id, Name = g.Name })
            .ToList();

        if (newGenres.Any())
        {
          await _uow.Genres.AddRangeAsync(newGenres);
          await _uow.SaveAsync();
          foreach (var g in newGenres)
            genreMap[g.TmdbId] = g;
        }

        foreach (var (movie, genreDtos) in movieGenrePairs)
        {
          foreach (var dto in genreDtos)
            if (genreMap.TryGetValue(dto.Id, out var genre))
              movie.Genres.Add(genre);
        }

        var moviesToAdd = movieGenrePairs.Select(p => p.Movie).ToList();
        await _uow.Movies.CreateRangeAsync(moviesToAdd);
        await _uow.SaveAsync();

        result.ImportedTitles = moviesToAdd.Select(m => m.Title).ToList();
      }

      result.SkippedCount = existingIds.Count;
      return result;
    }


    public async Task<IEnumerable<MovieSearchResultDto>> SearchMoviesAsync(string query, CancellationToken cancellationToken)
    {
      var results = await _tmdbService.SearchMoviesAsync(query, cancellationToken);

      return results.Select(m => new MovieSearchResultDto
      {
        Value = m.TmdbId,
        Text = m.Title,
        Year = m.ReleaseDate?.Length >= 4 ? m.ReleaseDate[..4] : "N/A",
        Rating = m.VoteAverage.ToString("F1"),
        Poster = m.PosterPath,
        Overview = m.Overview
      });
    }

    public async Task<bool> UpdateStatusAsync(int id, MovieStatus status)
    {
      var movie = await _uow.Movies.GetAsync(m => m.Id == id);
      if (movie == null) return false;

      movie.Status = status;

      await _uow.Movies.UpdateAsync(movie);
      await _uow.SaveAsync();

      return true;
    }

    public async Task<IEnumerable<MovieDropdownDto>> GetAllActiveAsync()
    {
      var movies = await _uow.Movies.GetAllWithSpecAsync(
          new MovieSpecification(MovieStatus.Active, null));

      return movies.Select(m => new MovieDropdownDto
      {
        Id = m.Id,
        Title = m.Title,
        Runtime = m.RuntimeMinutes,
        PosterPath = m.PosterPath,     // for the modal dropdown card
      });
    }

    public async Task<IEnumerable<ActiveMovieWithDetailsDto>> GetAllActiveWithDetailsAsync(CancellationToken ct = default)
    {
      // Pass 'true' to include genres, and set status to Active
      var spec = new MovieSpecification(MovieStatus.Active, null, includeGenres: true);
      var movies = await _uow.Movies.GetAllWithSpecAsync(spec, ct);

      return movies.Select(m => new ActiveMovieWithDetailsDto
      {
        Id = m.Id,
        Title = m.Title,
        Overview = m.Overview,
        PosterPath = m.PosterPath,
        BackdropPath = m.BackdropPath,
        VoteAverage = m.VoteAverage,
        TrailerKey = m.TrailerKey,
        Runtime = m.RuntimeMinutes,
        ReleaseDate = DateOnly.FromDateTime(m.ReleaseDate),
        Language = m.Language,
        Genres = m.Genres.Select(g => g.Name).ToList()
      });
    }

    public async Task<ActiveMovieWithDetailsDto?> GetActiveMovieWithDetailsByIdAsync(int id, CancellationToken ct = default)
    {
      var spec = new MovieSpecification(id, includeGenres: true);
      var movie = await _uow.Movies.GetEntityWithSpecAsync(spec, ct);

      if (movie == null) return null;

      return new ActiveMovieWithDetailsDto
      {
        Id = movie.Id,
        Title = movie.Title,
        Overview = movie.Overview,
        PosterPath = movie.PosterPath,
        BackdropPath = movie.BackdropPath,
        VoteAverage = movie.VoteAverage,
        TrailerKey = movie.TrailerKey,
        Runtime = movie.RuntimeMinutes,
        ReleaseDate = DateOnly.FromDateTime(movie.ReleaseDate),
        Language = movie.Language,
        Genres = movie.Genres.Select(g => g.Name).ToList()
      };
    }

    private static MovieStatus? MapStatus(string? segmentedFilter)
    {
      return segmentedFilter?.ToLower() switch
      {
        "active" => MovieStatus.Active,
        "coming" => MovieStatus.ComingSoon,
        "archived" => MovieStatus.Archived,
        _ => null
      };
    }
  }
}
