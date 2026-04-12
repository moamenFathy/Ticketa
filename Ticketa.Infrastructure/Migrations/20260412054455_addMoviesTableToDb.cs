using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ticketa.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class addMoviesTableToDb : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Movies",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TmdbId = table.Column<int>(type: "int", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Overview = table.Column<string>(type: "nvarchar(2000)", maxLength: 2000, nullable: false),
                    PosterPath = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    BackdropPath = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    TrailerKey = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    VoteAverage = table.Column<double>(type: "float", nullable: false),
                    ReleaseDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Language = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    ImportedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Movies", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Movies_TmdbId",
                table: "Movies",
                column: "TmdbId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Movies");
        }
    }
}
