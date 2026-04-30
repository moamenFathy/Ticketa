using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ticketa.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class HallTypeTemplate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "TotalSeats",
                table: "Halls",
                newName: "Type");

            migrationBuilder.AddColumn<int>(
                name: "SeatsPerRow",
                table: "Halls",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "TotalRows",
                table: "Halls",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.UpdateData(
                table: "Halls",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "SeatsPerRow", "TotalRows", "Type" },
                values: new object[] { 12, 10, 0 });

            migrationBuilder.UpdateData(
                table: "Halls",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "Name", "SeatsPerRow", "TotalRows", "Type" },
                values: new object[] { "IMAX Hall", 16, 14, 1 });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SeatsPerRow",
                table: "Halls");

            migrationBuilder.DropColumn(
                name: "TotalRows",
                table: "Halls");

            migrationBuilder.RenameColumn(
                name: "Type",
                table: "Halls",
                newName: "TotalSeats");

            migrationBuilder.UpdateData(
                table: "Halls",
                keyColumn: "Id",
                keyValue: 1,
                column: "TotalSeats",
                value: 200);

            migrationBuilder.UpdateData(
                table: "Halls",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "Name", "TotalSeats" },
                values: new object[] { "VIP Lounge", 50 });
        }
    }
}
