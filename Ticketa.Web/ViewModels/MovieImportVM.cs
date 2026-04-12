using Ticketa.Core.DTOs;

namespace Ticketa.Web.ViewModels
{
  public class MovieImportVM
  {
    // Populated from TMDB for the dropdown

    public List<TmdbMovieDto> AvailableMovies { get; set; } = new();

    // The admin's selection (submitted via form)
    public int SelectedTmdbId { get; set; }
  }
}
