#!/bin/bash

# Database Setup Script for Todo Application
# This script creates the PostgreSQL database and user

echo "=================================="
echo "Todo App Database Setup"
echo "=================================="
echo ""

# Database configuration
DB_NAME="todo_db"
DB_USER="todo_user"
DB_PASSWORD="todo_password"

echo "This script will create:"
echo "  - Database: $DB_NAME"
echo "  - User: $DB_USER"
echo "  - Password: $DB_PASSWORD"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Setup cancelled."
    exit 1
fi

echo ""
echo "Creating database and user..."
echo ""

# Create database and user using sudo
sudo -u postgres psql << EOF
-- Create database
CREATE DATABASE $DB_NAME;

-- Create user
CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';

-- Set user settings
ALTER ROLE $DB_USER SET client_encoding TO 'utf8';
ALTER ROLE $DB_USER SET default_transaction_isolation TO 'read committed';
ALTER ROLE $DB_USER SET timezone TO 'UTC';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;

-- Display confirmation
\echo '✓ Database created successfully'
\echo '✓ User created successfully'
\echo '✓ Privileges granted'
EOF

echo ""
echo "=================================="
echo "✓ Database setup complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. cd backend"
echo "  2. pip install -r requirements.txt"
echo "  3. python manage.py migrate"
echo "  4. python manage.py runserver"
echo ""
