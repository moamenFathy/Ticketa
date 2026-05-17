using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Configuration
{
  internal class MovieConfiguration : IEntityTypeConfiguration<Movie>
  {
    public void Configure(EntityTypeBuilder<Movie> builder)
    {
      builder.HasKey(m => m.Id);

      builder.HasIndex(m => m.TmdbId).IsUnique();

      builder.Property(m => m.Title)
        .IsRequired()
        .HasMaxLength(200);

      builder.Property(m => m.Overview)
        .HasMaxLength(2000);

      builder.Property(m => m.PosterPath)
        .HasMaxLength(300);

      builder.Property(m => m.BackdropPath)
        .HasMaxLength(300);

      builder.Property(m => m.TrailerKey)
        .HasMaxLength(50);

      builder.Property(m => m.Language)
        .HasMaxLength(10);
    }
  }
}
