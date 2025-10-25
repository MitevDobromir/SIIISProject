# Quick Start Guide

Get the Todo app running in 5 minutes!

## Step 1: Setup Database (2 minutes)

### Option A: Automated Setup
```bash
./setup_database.sh
```

### Option B: Manual Setup
```bash
sudo -u postgres psql
CREATE DATABASE todo_db;
CREATE USER todo_user WITH PASSWORD 'todo_password';
GRANT ALL PRIVILEGES ON DATABASE todo_db TO todo_user;
\q
```

## Step 2: Setup Backend (2 minutes)

```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Create database tables
python manage.py migrate

# Start the server
python manage.py runserver
```

Backend will be running at: http://localhost:8000

## Step 3: Open Frontend (1 minute)

### Option A: Direct Open
Open `frontend/index.html` in your browser

### Option B: Using HTTP Server
```bash
cd frontend
python -m http.server 3000
```

Then open: http://localhost:3000

## ✅ You're Done!

You should now see the Todo application interface. Try:
1. Adding a new task
2. Marking it as complete
3. Viewing the statistics

## Troubleshooting

### "Can't connect to database"
- Make sure PostgreSQL is running: `sudo service postgresql status`
- Check credentials in `backend/config/settings.py`

### "CORS error"
- Make sure backend is running on port 8000
- Check that frontend is calling the correct API URL in `app.js`

### "Module not found"
- Install dependencies: `pip install -r requirements.txt`

## Testing the API

```bash
# Create a todo
curl -X POST http://localhost:8000/api/todos/ \
  -H "Content-Type: application/json" \
  -d '{"title": "My first task", "description": "Testing the API"}'

# Get all todos
curl http://localhost:8000/api/todos/

# Get statistics
curl http://localhost:8000/api/todos/statistics/
```

## Architecture Layers

This project demonstrates 4 layers:

1. **Presentation** (views.py, serializers.py, frontend) - Handles UI and API
2. **Business Logic** (service.py) - Contains business rules
3. **Data Access** (repository.py, models.py) - Manages database operations
4. **Database** (PostgreSQL) - Stores data

Each layer only communicates with the layer directly below it!
