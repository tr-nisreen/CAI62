using Microsoft.EntityFrameworkCore;
using SchoolApi.Data;

var builder = WebApplication.CreateBuilder(args);

// 1) Connect Entity Framework Core to SQL Server.
//    The connection string is in appsettings.json ("DefaultConnection").
builder.Services.AddDbContext<SchoolDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// 2) Controllers (our API endpoints) and Swagger (the test page in the browser).
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// 3) Swagger is ON in every environment, so students can always test the API.
app.UseSwagger();
app.UseSwaggerUI();

// Opening the home page "/" takes you straight to Swagger.
app.MapGet("/", () => Results.Redirect("/swagger")).ExcludeFromDescription();

app.MapControllers();

app.Run();
