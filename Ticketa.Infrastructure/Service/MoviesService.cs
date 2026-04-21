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

      // 4. DataTables response
      return new
      {
        draw = request.Draw,
        recordsTotal = total,
        recordsFiltered = filtered,
        data = movies
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

      var moviesToAdd = new List<Movie>();

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

        moviesToAdd.Add(movie);
      }

      if (moviesToAdd.Any())
      {
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
