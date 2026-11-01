#!/usr/bin/env bash
# Waits until SQL Server is accepting connections on localhost:1433.
# SQL Server needs about 20-60 seconds to start the first time.
echo "Waiting for SQL Server to start..."
for i in $(seq 1 90); do
  if (echo > /dev/tcp/127.0.0.1/1433) >/dev/null 2>&1; then
    echo "SQL Server is listening on port 1433."
    exit 0
  fi
  sleep 2
done
echo "SQL Server did not start in 3 minutes. See TEACHER_SETUP.md -> Troubleshooting."
exit 0
