using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SchoolApi.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Students",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FullName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Grade = table.Column<int>(type: "int", nullable: false),
                    Section = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: false),
                    DateOfBirth = table.Column<DateOnly>(type: "date", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Students", x => x.Id);
                });

            migrationBuilder.InsertData(
                table: "Students",
                columns: new[] { "Id", "DateOfBirth", "Email", "FullName", "Grade", "Section" },
                values: new object[,]
                {
                    { 1, new DateOnly(2010, 3, 14), "omar.almansoori@school.ae", "Omar Al Mansoori", 10, "A" },
                    { 2, new DateOnly(2010, 7, 2), "fatima.alhashimi@school.ae", "Fatima Al Hashimi", 10, "A" },
                    { 3, new DateOnly(2009, 11, 21), "yousef.khalil@school.ae", "Yousef Khalil", 10, "B" },
                    { 4, new DateOnly(2009, 1, 30), "mariam.saeed@school.ae", "Mariam Saeed", 11, "A" },
                    { 5, new DateOnly(2008, 9, 8), "ahmed.rashid@school.ae", "Ahmed Rashid", 11, "B" },
                    { 6, new DateOnly(2008, 12, 17), "layla.haddad@school.ae", "Layla Haddad", 11, "B" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Students_Email",
                table: "Students",
                column: "Email",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Students");
        }
    }
}
