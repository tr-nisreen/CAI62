/* =====================================================================
   SQL PRACTICE - Microsoft SQL Server
   ---------------------------------------------------------------------
   HOW TO RUN:
     1. Make sure you are connected to "Classroom SQL Server"
        (SQL Server icon on the left side bar).
     2. Select a few lines with your mouse, then press  Ctrl + Shift + E
        (Mac: Cmd + Shift + E)  to run ONLY the selected lines.
        Or click the green "Run" button at the top to run the whole file.
     3. The results appear in a table on the right.

   This file uses its own database called PracticeDb, so it does NOT
   touch the SchoolDb database that the API uses.
   You can run this whole file again at any time to start fresh.
   ===================================================================== */


/* ---------- 0. CREATE A PRACTICE DATABASE ---------- */
-- Create the database only if it does not exist yet.
IF DB_ID('PracticeDb') IS NULL
    CREATE DATABASE PracticeDb;
GO

-- From now on, work inside PracticeDb.
USE PracticeDb;
GO

-- Start fresh: delete old tables if they exist.
-- (Enrollments first, because it points to the other two tables.)
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;
GO


/* ---------- 1. CREATE TABLE ---------- */
-- A table is like an Excel sheet: columns (what we store) and rows (the data).
CREATE TABLE Students (
    StudentId   INT IDENTITY(1,1) PRIMARY KEY,  -- unique number, SQL Server fills it in (1, 2, 3...)
    FullName    NVARCHAR(100) NOT NULL,         -- text, up to 100 letters, cannot be empty
    Grade       INT           NOT NULL,         -- a whole number: 10, 11...
    Section     NVARCHAR(10)  NOT NULL,         -- "A", "B"...
    Email       NVARCHAR(150) NULL,             -- NULL means "this can be empty"
    DateOfBirth DATE          NOT NULL          -- only a date, no time
);

CREATE TABLE Courses (
    CourseId    INT IDENTITY(1,1) PRIMARY KEY,
    CourseName  NVARCHAR(100) NOT NULL,
    Hours       INT           NOT NULL
);

-- Enrollments connects Students and Courses:
-- "which student is taking which course, and what mark they got".
CREATE TABLE Enrollments (
    EnrollmentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId    INT NOT NULL FOREIGN KEY REFERENCES Students(StudentId),  -- must be a real student
    CourseId     INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseId),    -- must be a real course
    Mark         INT NULL
);
GO


/* ---------- 2. INSERT (add rows) ---------- */
-- We do not write StudentId: SQL Server creates it for us.
INSERT INTO Students (FullName, Grade, Section, Email, DateOfBirth)
VALUES
    ('Omar Al Mansoori',  10, 'A', 'omar@school.ae',   '2010-03-14'),
    ('Fatima Al Hashimi', 10, 'A', 'fatima@school.ae', '2010-07-02'),
    ('Yousef Khalil',     10, 'B', NULL,               '2009-11-21'),
    ('Mariam Saeed',      11, 'A', 'mariam@school.ae', '2009-01-30'),
    ('Ahmed Rashid',      11, 'B', 'ahmed@school.ae',  '2008-09-08'),
    ('Layla Haddad',      11, 'B', 'layla@school.ae',  '2008-12-17');

INSERT INTO Courses (CourseName, Hours)
VALUES
    ('C# Programming', 4),   -- CourseId 1
    ('Databases (SQL)', 3),  -- CourseId 2
    ('Web APIs',        3);  -- CourseId 3

INSERT INTO Enrollments (StudentId, CourseId, Mark)
VALUES
    (1, 1, 88), (1, 2, 92),              -- Omar:   C#, Databases
    (2, 1, 95), (2, 3, 90),              -- Fatima: C#, Web APIs
    (3, 1, 75), (3, 2, 70),              -- Yousef: C#, Databases
    (4, 1, 85), (4, 2, 78), (4, 3, 94),  -- Mariam: all 3 courses
    (5, 3, 65);                          -- Ahmed:  Web APIs
    -- Layla (StudentId 6) has no courses yet. Remember this for the JOIN part!
GO


/* ---------- 3. SELECT (read data) ---------- */
-- * means "all columns"
SELECT * FROM Students;

-- Only some columns
SELECT FullName, Grade, Section FROM Students;

-- Give a column a nicer name with AS
SELECT FullName AS [Student Name], Grade FROM Students;


/* ---------- 4. WHERE (filter rows) ---------- */
-- Only grade 11
SELECT * FROM Students WHERE Grade = 11;

-- Grade 10 AND section A
SELECT * FROM Students WHERE Grade = 10 AND Section = 'A';

-- Names that start with "A"  (% means "anything after")
SELECT * FROM Students WHERE FullName LIKE 'A%';

-- Students with no email (use IS NULL, not = NULL)
SELECT * FROM Students WHERE Email IS NULL;


/* ---------- 5. ORDER BY (sort) ---------- */
-- A to Z
SELECT * FROM Students ORDER BY FullName ASC;

-- Youngest first (the biggest date first)
SELECT FullName, DateOfBirth FROM Students ORDER BY DateOfBirth DESC;


/* ---------- 6. TOP (only the first rows) ---------- */
-- TOP is how SQL Server says "only give me the first N rows".
-- (Other databases use LIMIT, but SQL Server uses TOP.)
SELECT TOP 3 * FROM Students ORDER BY StudentId;

-- The 3 highest marks
SELECT TOP 3 * FROM Enrollments ORDER BY Mark DESC;


/* ---------- 7. JOIN (combine tables) ---------- */
-- INNER JOIN: only students who HAVE courses.
SELECT s.FullName, c.CourseName, e.Mark
FROM Enrollments AS e
INNER JOIN Students AS s ON e.StudentId = s.StudentId
INNER JOIN Courses  AS c ON e.CourseId  = c.CourseId
ORDER BY s.FullName;

-- LEFT JOIN: ALL students, even those with no courses.
-- Look for Layla: her course is NULL because she has no enrollments.
SELECT s.FullName, c.CourseName
FROM Students AS s
LEFT JOIN Enrollments AS e ON s.StudentId = e.StudentId
LEFT JOIN Courses     AS c ON e.CourseId  = c.CourseId
ORDER BY s.FullName;


/* ---------- 8. GROUP BY (count, average, ...) ---------- */
-- How many students in each grade?
SELECT Grade, COUNT(*) AS NumberOfStudents
FROM Students
GROUP BY Grade;

-- Average mark in each course
SELECT c.CourseName, AVG(e.Mark) AS AverageMark, COUNT(*) AS Students
FROM Enrollments AS e
INNER JOIN Courses AS c ON e.CourseId = c.CourseId
GROUP BY c.CourseName;

-- HAVING filters groups (WHERE filters rows): courses with more than 3 students
SELECT c.CourseName, COUNT(*) AS Students
FROM Enrollments AS e
INNER JOIN Courses AS c ON e.CourseId = c.CourseId
GROUP BY c.CourseName
HAVING COUNT(*) > 3;


/* ---------- 9. UPDATE (change data) ---------- */
-- ALWAYS use WHERE with UPDATE, or you will change EVERY row!
UPDATE Students
SET Email = 'yousef@school.ae'
WHERE StudentId = 3;

-- Add 5 bonus marks to everyone in course 3 (Web APIs)
UPDATE Enrollments
SET Mark = Mark + 5
WHERE CourseId = 3;

-- Check the result
SELECT * FROM Students WHERE StudentId = 3;
SELECT * FROM Enrollments WHERE CourseId = 3;


/* ---------- 10. DELETE (remove data) ---------- */
-- ALWAYS use WHERE with DELETE, or you will delete EVERY row!
-- Delete one enrollment (Omar leaves C# Programming)
DELETE FROM Enrollments WHERE EnrollmentId = 1;

-- To delete a student, first delete their enrollments (the foreign key protects us).
DELETE FROM Enrollments WHERE StudentId = 5;
DELETE FROM Students    WHERE StudentId = 5;

SELECT * FROM Students;


/* ---------- 11. BONUS: look at the API's database ---------- */
-- The Web API (SchoolApi) uses another database called SchoolDb.
-- Run the API, add a student in Swagger, then run this to see it in SQL:
-- SELECT * FROM SchoolDb.dbo.Students;


/* ---------- YOUR TURN ---------- */
-- 1. Add yourself to the Students table.
-- 2. Show all grade 10 students sorted by name.
-- 3. Show the name of every student who got more than 85, with the course name.
-- 4. Count how many courses each student is taking (use JOIN + GROUP BY).
