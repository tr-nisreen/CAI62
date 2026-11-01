using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SchoolApi.Data;
using SchoolApi.Models;

namespace SchoolApi.Controllers;

// All URLs in this controller start with /api/students
[ApiController]
[Route("api/[controller]")]
public class StudentsController : ControllerBase
{
    private readonly SchoolDbContext _db;

    public StudentsController(SchoolDbContext db)
    {
        _db = db;
    }

    // READ ALL:  GET /api/students
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Student>>> GetAll()
    {
        return await _db.Students.OrderBy(s => s.Id).ToListAsync();
    }

    // READ ONE:  GET /api/students/3
    [HttpGet("{id:int}")]
    public async Task<ActionResult<Student>> GetById(int id)
    {
        var student = await _db.Students.FindAsync(id);
        if (student == null)
        {
            return NotFound();               // 404
        }
        return student;                      // 200 + the student
    }

    // CREATE:  POST /api/students   (send the student as JSON, without "id")
    [HttpPost]
    public async Task<ActionResult<Student>> Create(Student student)
    {
        student.Id = 0;                      // SQL Server chooses the Id
        _db.Students.Add(student);
        if (!await TrySaveAsync())
        {
            return Conflict("A student with this email already exists.");   // 409
        }
        return CreatedAtAction(nameof(GetById), new { id = student.Id }, student);   // 201
    }

    // UPDATE:  PUT /api/students/3   (the "id" in the URL and in the JSON must match)
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, Student student)
    {
        if (id != student.Id)
        {
            return BadRequest("The id in the URL and the id in the body must be the same.");  // 400
        }

        var existing = await _db.Students.FindAsync(id);
        if (existing == null)
        {
            return NotFound();               // 404
        }

        existing.FullName = student.FullName;
        existing.Grade = student.Grade;
        existing.Section = student.Section;
        existing.Email = student.Email;
        existing.DateOfBirth = student.DateOfBirth;

        if (!await TrySaveAsync())
        {
            return Conflict("A student with this email already exists.");   // 409
        }
        return NoContent();                  // 204 = done, nothing to show
    }

    // DELETE:  DELETE /api/students/3
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var student = await _db.Students.FindAsync(id);
        if (student == null)
        {
            return NotFound();               // 404
        }

        _db.Students.Remove(student);
        await _db.SaveChangesAsync();
        return NoContent();                  // 204
    }

    // Saves changes. Returns false if the database refused them
    // (for example: two students with the same email).
    private async Task<bool> TrySaveAsync()
    {
        try
        {
            await _db.SaveChangesAsync();
            return true;
        }
        catch (DbUpdateException)
        {
            return false;
        }
    }
}
