using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ticketa.Infrastructure.Migrations
{
  /// <inheritdoc />
  public partial class addStatusAndRuntimeColumnsToMovies : Migration
  {
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
      migrationBuilder.AddColumn<int>(
          name: "RuntimeMinutes",
          table: "Movies",
          type: "int",
          nullable: false,
          defaultValue: 0);

      migrationBuilder.AddColumn<int>(
          name: "Status",
          table: "Movies",
          type: "int",
          nullable: false,
          defaultValue: 0);
    }

    /// <inheritdoc />

  }
}
