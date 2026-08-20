using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ticketa.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class addArchiveAndArchivedAtToMoviesAndShowtimesTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "ArchivedAt",
                table: "Showtimes",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsArchived",
                table: "Showtimes",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "ArchivedAt",
                table: "Movies",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsArchived",
                table: "Movies",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.CreateIndex(
                name: "IX_Showtimes_IsArchived",
                table: "Showtimes",
                column: "IsArchived",
                filter: "[IsArchived] = 0");

            migrationBuilder.CreateIndex(
                name: "IX_Movies_IsArchived",
                table: "Movies",
                column: "IsArchived",
                filter: "[IsArchived] = 0");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Showtimes_IsArchived",
                table: "Showtimes");

            migrationBuilder.DropIndex(
                name: "IX_Movies_IsArchived",
                table: "Movies");

            migrationBuilder.DropColumn(
                name: "ArchivedAt",
                table: "Showtimes");

            migrationBuilder.DropColumn(
                name: "IsArchived",
                table: "Showtimes");

            migrationBuilder.DropColumn(
                name: "ArchivedAt",
                table: "Movies");

            migrationBuilder.DropColumn(
                name: "IsArchived",
                table: "Movies");
        }
    }
}
