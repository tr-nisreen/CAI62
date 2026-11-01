#!/usr/bin/env bash
# Runs ONE time, when a codespace is created.
# 1) restores NuGet packages  2) installs dotnet-ef
# 3) waits for SQL Server     4) creates the SchoolDb database (EF migrations + seed data)
set -u
cd "$(dirname "$0")/.."

echo "==> Restoring .NET tools (dotnet-ef) and NuGet packages"
dotnet tool restore
dotnet restore SchoolApi.sln

bash .devcontainer/wait-for-sql.sh

echo "==> Creating / updating the SchoolDb database"
# The port can be open before SQL Server accepts logins, so try a few times.
for i in $(seq 1 15); do
  if dotnet ef database update --project SchoolApi; then
    echo ""
    echo "============================================================"
    echo " All set! Run the API with:   cd SchoolApi && dotnet run"
    echo " SQL Server: localhost,1433   user: sa   password: Student@12345"
    echo "============================================================"
    exit 0
  fi
  echo "SQL Server is not ready yet (try $i of 15). Waiting 10 seconds..."
  sleep 10
done
echo "Could not create the database. Open a terminal and run:"
echo "   dotnet ef database update --project SchoolApi"
exit 0
