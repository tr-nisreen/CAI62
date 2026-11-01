using Microsoft.EntityFrameworkCore;
using SchoolApi.Models;

namespace SchoolApi.Data;

// The DbContext is the "bridge" between our C# code and the SQL Server database.
public class SchoolDbContext : DbContext
{
    public SchoolDbContext(DbContextOptions<SchoolDbContext> options) : base(options)
    {
    }

    // This becomes the "Students" table.
    public DbSet<Student> Students => Set<Student>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // No two students can have the same email.
        modelBuilder.Entity<Student>()
            .HasIndex(s => s.Email)
            .IsUnique();

        // Seed data: these students are added when the database is created.
        modelBuilder.Entity<Student>().HasData(
            new Student { Id = 1, FullName = "Omar Al Mansoori",  Grade = 10, Section = "A", Email = "omar.almansoori@school.ae",  DateOfBirth = new DateOnly(2010, 3, 14) },
            new Student { Id = 2, FullName = "Fatima Al Hashimi", Grade = 10, Section = "A", Email = "fatima.alhashimi@school.ae", DateOfBirth = new DateOnly(2010, 7, 2) },
            new Student { Id = 3, FullName = "Yousef Khalil",     Grade = 10, Section = "B", Email = "yousef.khalil@school.ae",    DateOfBirth = new DateOnly(2009, 11, 21) },
            new Student { Id = 4, FullName = "Mariam Saeed",      Grade = 11, Section = "A", Email = "mariam.saeed@school.ae",     DateOfBirth = new DateOnly(2009, 1, 30) },
            new Student { Id = 5, FullName = "Ahmed Rashid",      Grade = 11, Section = "B", Email = "ahmed.rashid@school.ae",     DateOfBirth = new DateOnly(2008, 9, 8) },
            new Student { Id = 6, FullName = "Layla Haddad",      Grade = 11, Section = "B", Email = "layla.haddad@school.ae",     DateOfBirth = new DateOnly(2008, 12, 17) }
        );
    }
}
