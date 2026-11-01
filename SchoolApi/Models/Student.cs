using System.ComponentModel.DataAnnotations;

namespace SchoolApi.Models;

// A Student is one row in the "Students" table.
// Each property below becomes one column.
public class Student
{
    // Primary key. SQL Server gives each new student the next number (1, 2, 3...).
    public int Id { get; set; }

    [Required]
    [StringLength(100)]
    public string FullName { get; set; } = string.Empty;

    // Grade 10, 11 or 12
    [Range(1, 12)]
    public int Grade { get; set; }

    // Section, for example "A" or "CAI"
    [Required]
    [StringLength(10)]
    public string Section { get; set; } = string.Empty;

    [Required]
    [EmailAddress]
    [StringLength(150)]
    public string Email { get; set; } = string.Empty;

    // Only the date (no time). Write it like "2009-03-14".
    public DateOnly DateOfBirth { get; set; }
}
