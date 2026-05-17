using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;
using Ticketa.Core.Enums;
using Ticketa.Core.Helpers;

namespace Ticketa.Infrastructure.Configuration
{
  public class HallConfiguration : IEntityTypeConfiguration<Hall>
  {
    public void Configure(EntityTypeBuilder<Hall> builder)
    {
      // TotalSeats is computed — not stored
      builder.Ignore(h => h.TotalSeats);

      var standardTemplate = HallTypeHelper.GetTemplate(HallType.Standard);
      var imaxTemplate     = HallTypeHelper.GetTemplate(HallType.IMAX);

      builder.HasData(
        new Hall
        {
          Id          = 1,
          Name        = "Main Hall",
          Type        = HallType.Standard,
          TotalRows   = standardTemplate.Rows,
          SeatsPerRow = standardTemplate.SeatsPerRow
        },
        new Hall
        {
          Id          = 2,
          Name        = "IMAX Hall",
          Type        = HallType.IMAX,
          TotalRows   = imaxTemplate.Rows,
          SeatsPerRow = imaxTemplate.SeatsPerRow
        }
      );
    }
  }
}
