#!/bin/sh

# Run migrations
npx prisma migrate deploy

# Check if database is already seeded (example: check if users table has data)
USER_COUNT=$(npx prisma db execute --stdin <<EOF
SELECT COUNT(*) FROM "User";
EOF
)

# If no users exist, run seed
if [ "$USER_COUNT" = "0" ]; then
  echo "Database is empty, running seed..."
  npm run seed || echo "Seed failed or not configured"
fi

# Start the server
node dist/src/server.js