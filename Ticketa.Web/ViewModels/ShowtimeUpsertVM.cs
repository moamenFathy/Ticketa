using Ticketa.Core.DTOs;

namespace Ticketa.Web.ViewModels
{
  public class ShowtimeUpsertVM
  {
    public ShowtimeUpsertDto Form { get; set; } = new();
    public IEnumerable<HallDto> Halls { get; set; } = [];
    public IEnumerable<MovieDropdownDto> Movies { get; set; } = [];
  }
}
