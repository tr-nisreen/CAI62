# Teacher Setup Guide

This repo is a **ready-made classroom workspace** for C#, ASP.NET Core Web API and MS SQL.
When a student opens it in GitHub Codespaces, they get VS Code in the browser with
.NET 8, SQL Server 2022, the C# Dev Kit and the SQL Server (mssql) extension — already set up,
with a working Students API (CRUD + Swagger) and a SQL practice file.

Time needed: about **15 minutes** once.

---

## Part 1 — Put it on GitHub (5 min)

1. Sign in to **github.com** → click **+** (top right) → **New repository**.
2. Name: for example `csharp-sql-classroom`. Choose **Public**
   (simplest for Codespaces and GitHub Classroom). Do **not** add a README. Click **Create repository**.
3. On the empty repo page, click **uploading an existing file**.
4. Unzip `codespaces-sql-api-template.zip` on your computer. Open the folder, select **everything inside it**
   (including the hidden folders `.devcontainer` and `.config`) and drag it into the browser. Click **Commit changes**.
   - ⚠️ Windows hides folders that start with a dot. In File Explorer: **View → Show → Hidden items**.
     On Mac: press **Cmd + Shift + .** in Finder.
   - After uploading, check the repo has the folders `.devcontainer`, `.config`, `SchoolApi`, `sql`.
   - Using Git instead? In the unzipped folder:
     ```
     git init
     git add .
     git commit -m "Classroom template"
     git branch -M main
     git remote add origin https://github.com/YOUR-USERNAME/csharp-sql-classroom.git
     git push -u origin main
     ```
5. Go to **Settings** (of the repo) → under the repository name, tick ✅ **Template repository**.
6. (Optional) Edit `README.md` and replace `YOUR-USERNAME/YOUR-REPO-NAME` in the first lines
   with your username and repo name, so the "Open in GitHub Codespaces" button works.

## Part 2 — Test it once yourself (5–10 min)

1. In your repo: **Code** → **Codespaces** → **Create codespace on main**.
2. Wait until the terminal says **"All set!"** (2–4 minutes the first time).
3. Run the API:
   ```
   cd SchoolApi
   dotnet run
   ```
   Click **Open in Browser** on the pop-up → the Swagger page opens → try **GET /api/students** (6 students).
4. Click the **SQL Server** icon on the left → **Classroom SQL Server** → open `sql/practice.sql` → run it.
5. **Stop the codespace** when you finish: github.com/codespaces → **⋯** → **Stop codespace**.

---

## Part 3 — How to send students to it

### Option A (recommended for class): GitHub Classroom ⭐
Each student gets their **own copy** of the repo, and you can see everyone's work in one place.

1. Go to **classroom.github.com** → sign in → **New classroom**.
   GitHub Classroom needs an **organization**; create a new free one when it asks (e.g. `ms-nisreen-cs-2026`).
2. Add your students list (optional, you can link names later).
3. **New assignment** → **Create an individual assignment**.
   - Title: e.g. `Students API + SQL`.
   - Repository visibility: Private (students cannot see each other's work).
4. **Starter code**: search and choose your template repo (`YOUR-USERNAME/csharp-sql-classroom`).
5. **Supported editor**: choose **GitHub Codespaces**.
6. Finish → copy the **invite link** and send it to students (Teams, email, Blackboard...).
7. The student clicks the link → **Accept this assignment** → opens their repo → **Code → Codespaces → Create codespace**
   (or the "Open in GitHub Codespaces" button on the Classroom page).
8. **Where you see their work:** classroom.github.com → your classroom → the assignment.
   You see every student, their repo, and their last commit. Students must **Commit** and **Sync/Push** their changes
   (Source Control icon on the left) so you can see them.

💡 If you are verified as a teacher in **GitHub Education** (education.github.com), you can turn on the
Codespaces education benefit for your classroom organization, so students get extra free hours.
Look for the Codespaces option in the classroom settings.

### Option B (quick): share the link
Good for a quick lab or a demo.

- **One click:** send students this link (replace with your names):
  `https://codespaces.new/YOUR-USERNAME/csharp-sql-classroom`
  → they click **Create codespace** and it opens. Their changes stay in their codespace
  (they cannot push to your repo).
- **Their own copy:** send them your repo link → they click **Use this template** → **Create a new repository**
  → in their new repo: **Code → Codespaces → Create codespace on main**. You do not see their work unless they share their repo link.

### Rules to tell students
- Everyone needs a free GitHub account (age 13+).
- **Stop the codespace after every class** (free hours: about 60 hours/month; ~90 with GitHub Education for students).
- Open the **same** codespace next time (github.com/codespaces), don't create a new one each class.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Terminal says *"SQL Server is not ready yet"* | Normal for the first 1–2 minutes. It retries by itself. |
| API error: *"A network-related error... SQL Server"* | SQL Server is still starting. Wait 1 minute and run again. If it continues: ☰ menu → View → Command Palette → **Codespaces: Rebuild Container**. |
| *"Cannot open database SchoolDb"* | In the terminal: `dotnet ef database update --project SchoolApi` |
| Swagger page does not open | **PORTS** tab → port 5000 → 🌐 globe icon. Add `/swagger` to the end of the URL. |
| Port 5000 not in the PORTS tab | Make sure `dotnet run` is still running. Or click **Forward a Port** → type `5000`. |
| *"Address already in use"* | Another `dotnet run` is running. Ctrl + C in the other terminal, or close it. |
| SQL Server extension cannot connect | Server `localhost,1433`, SQL Login, user `sa`, password `Student@12345`, Trust server certificate = Yes. |
| `dotnet ef` not found | Run `dotnet tool restore` in the main folder. |
| Codespace is very slow | Use at least the **2-core** machine (default). Close extra browser tabs. |
| Student ran out of free hours | They wait for next month, or use Classroom with the education benefit. Remind them to stop codespaces. |
| Start again from zero (database too) | Command Palette → **Codespaces: Rebuild Container**, then `dotnet ef database update --project SchoolApi`. To also reset data: `dotnet ef database drop -f --project SchoolApi` then `update` again. |

---

## What's inside

```
.devcontainer/
  devcontainer.json    ← VS Code settings, extensions, ports, SQL connection
  docker-compose.yml   ← 2 containers: .NET 8 (app) + SQL Server 2022 (db)
  setup.sh             ← runs once: restore, install dotnet-ef, create SchoolDb
  wait-for-sql.sh      ← waits for SQL Server to start
.config/dotnet-tools.json  ← installs dotnet-ef (Entity Framework tool)
SchoolApi.sln
SchoolApi/             ← ASP.NET Core Web API (.NET 8) + EF Core + Swagger
sql/practice.sql       ← SQL lessons: CREATE, INSERT, SELECT, WHERE, ORDER BY, TOP, JOIN, GROUP BY, UPDATE, DELETE
README.md              ← for students
```

🔒 **Security note:** the SQL password `Student@12345` is for the classroom only.
Each codespace has its own private SQL Server; nobody else can reach it.
