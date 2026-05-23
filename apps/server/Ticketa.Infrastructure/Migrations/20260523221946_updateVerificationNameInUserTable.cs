using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ticketa.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class updateVerificationNameInUserTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "VerficationCodeExpiry",
                table: "AspNetUsers",
                newName: "VerificationCodeExpiry");

            migrationBuilder.RenameColumn(
                name: "VerficationCode",
                table: "AspNetUsers",
                newName: "VerificationCode");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "VerificationCodeExpiry",
                table: "AspNetUsers",
                newName: "VerficationCodeExpiry");

            migrationBuilder.RenameColumn(
                name: "VerificationCode",
                table: "AspNetUsers",
                newName: "VerficationCode");
        }
    }
}
