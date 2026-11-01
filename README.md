# 🎓 C# + ASP.NET Core + SQL Server — Student Workspace

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/YOUR-USERNAME/YOUR-REPO-NAME)

Everything you need is already installed: **.NET 8**, **SQL Server 2022**, and **VS Code** in your browser.
You do not need to install anything on your computer.

---

## 1. Open your codespace

1. Open your repository on GitHub.
2. Click the green **Code** button → **Codespaces** tab → **Create codespace on main**.
3. Wait **2–4 minutes** the first time. A terminal shows the setup.
   When you see **"All set!"**, you are ready.

> Next time, do NOT create a new one. Go to **github.com/codespaces** and open the codespace you already have.

---

## 2. Run the Web API

In the terminal (menu ☰ → **Terminal** → **New Terminal**), type:

```
cd SchoolApi
dotnet run
```

Wait until you see `Now listening on: http://localhost:5000`.
To stop the API: click in the terminal and press **Ctrl + C**.

---

## 3. Test the API in Swagger

1. A message appears: *"Your application running on port 5000 is available"* → click **Open in Browser**.
   - No message? Click the **PORTS** tab (next to TERMINAL) → find port **5000** → click the 🌐 globe icon.
2. The **Swagger** page opens. (If you see a blank page, add `/swagger` to the end of the address.)
3. Try it:
   - **GET /api/students** → **Try it out** → **Execute** → you see all students.
   - **GET /api/students/{id}** → type `1` → **Execute**.
   - **POST /api/students** → **Try it out** → paste this → **Execute**:
     ```json
     {
       "fullName": "Your Name",
       "grade": 10,
       "section": "A",
       "email": "your.name@school.ae",
       "dateOfBirth": "2010-05-20"
     }
     ```
   - **PUT /api/students/{id}** → change a student. The `id` in the box and in the JSON must be the same.
   - **DELETE /api/students/{id}** → delete a student.

| Code | Meaning |
|------|---------|
| 200 | OK — here is the data |
| 201 | Created — new student added |
| 204 | Done — nothing to show |
| 400 | Bad request — check your JSON |
| 404 | Not found — no student with this id |

---

## 4. Run SQL queries in VS Code

1. Click the **SQL Server** icon on the left side bar (it looks like a database / server).
2. Click the connection called **Classroom SQL Server** to connect.
   If it asks for details, use:

   | Setting | Value |
   |---------|-------|
   | Server | `localhost,1433` |
   | Authentication | SQL Login |
   | User name | `sa` |
   | Password | `Student@12345` |
   | Trust server certificate | Yes |

3. Open **sql/practice.sql**.
4. Select some lines and press **Ctrl + Shift + E** (Mac: **Cmd + Shift + E**) to run them.
   The results show on the right.

There are two databases:
- **PracticeDb** — for your SQL exercises (`sql/practice.sql`).
- **SchoolDb** — used by the Web API. Try: `SELECT * FROM SchoolDb.dbo.Students;`

---

## 5. Project files

```
SchoolApi/
  Models/Student.cs                 ← the Student class (= a row in the table)
  Data/SchoolDbContext.cs           ← connects C# to SQL Server + starting data
  Controllers/StudentsController.cs ← the API: GET, POST, PUT, DELETE
  Migrations/                       ← C# code that creates the tables
  Program.cs                        ← where the app starts
sql/practice.sql                    ← SQL exercises
```

Changed the `Student` class? Update the database with:

```
cd SchoolApi
dotnet ef migrations add MyChange
dotnet ef database update
```

---

## 6. ⛔ STOP your codespace after class!

Your free hours are limited (about **60 hours a month** on the free plan).
A running codespace uses hours even if you are not typing.

- Go to **github.com/codespaces** → click **⋯** next to your codespace → **Stop codespace**.
- Or in VS Code: bottom-left **Codespaces** → **Stop Current Codespace**.

It also stops by itself after 30 minutes of doing nothing, but please stop it yourself.
Stopping does **not** delete your work. Do not delete the codespace unless your teacher says so.

---

## Problems?

- **The API says it cannot connect to SQL Server** → SQL Server is still starting. Wait 1 minute and try again.
- **"Database does not exist"** → run `dotnet ef database update --project SchoolApi` in the terminal.
- **Port 5000 is already in use** → another `dotnet run` is still open. Press Ctrl + C in the other terminal, or close it (🗑️).
- Still stuck? Ask your teacher. 🙂

> 🔒 The password `Student@12345` is only for this classroom. Never use it for real accounts.
