using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ticketa.Core.Entities;

namespace Ticketa.Infrastructure.Configuration
{
  public class GenreConfiguration : IEntityTypeConfiguration<Genre>
  {
    public void Configure(EntityTypeBuilder<Genre> builder)
    {
      builder.HasKey(g => g.Id);

      builder.HasIndex(g => g.TmdbId).IsUnique();

      builder.Property(g => g.Name)
        .IsRequired()
        .HasMaxLength(100);

      builder.HasMany(g => g.Movies)
        .WithMany(m => m.Genres)
        .UsingEntity(j => j.ToTable("MovieGenres"));
    }
  }
}
