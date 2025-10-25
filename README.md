# Todo Application - Layered Architecture Demo

A full-stack Todo application demonstrating **layered architecture** principles with a clear separation of concerns.

## 🏗️ Architecture Overview

This project implements a classic **4-layer architecture**:

```
┌─────────────────────────────────────────────────────────┐
│          PRESENTATION LAYER (Frontend)                  │
│              HTML / CSS / JavaScript                    │
│         Views (views.py) | Serializers                 │
└─────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────┐
│          BUSINESS LOGIC LAYER                           │
│            Service Layer (service.py)                   │
│         Contains all business rules                     │
└─────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────┐
│          DATA ACCESS LAYER                              │
│      Repository Pattern (repository.py)                 │
│         Models (models.py)                              │
└─────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────┐
│          DATABASE LAYER                                 │
│              PostgreSQL                                 │
└─────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
todo_project/
├── backend/                    # Django Backend
│   ├── config/                # Django project configuration
│   │   ├── settings.py       # Database & app settings
│   │   ├── urls.py           # Main URL routing
│   │   └── wsgi.py           # WSGI configuration
│   ├── todo_app/             # Main application
│   │   ├── models.py         # 📊 Data Layer: Database models
│   │   ├── repository.py     # 📊 Data Layer: Repository pattern
│   │   ├── service.py        # 🔧 Business Layer: Business logic
│   │   ├── views.py          # 🌐 Presentation Layer: API endpoints
│   │   ├── serializers.py    # 🌐 Presentation Layer: Data transformation
│   │   ├── urls.py           # URL routing
│   │   └── admin.py          # Django admin configuration
│   ├── manage.py             # Django management script
│   └── requirements.txt      # Python dependencies
├── frontend/                  # Frontend Application
│   ├── index.html            # Main HTML page
│   ├── styles.css            # Styling
│   └── app.js                # JavaScript logic
└── README.md                 # This file
```

## 🎯 Layer Responsibilities

### 1. Presentation Layer (`views.py`, `serializers.py`, Frontend)
- **Responsibility**: Handle HTTP requests/responses and user interface
- **Files**: 
  - `views.py` - API endpoints and request handling
  - `serializers.py` - Data validation and transformation
  - Frontend files - User interface
- **Rule**: Only calls the Business Logic Layer, never directly accesses data

### 2. Business Logic Layer (`service.py`)
- **Responsibility**: Implement business rules and validation
- **Files**: `service.py`
- **Examples**:
  - Validate title is not empty
  - Enforce title length limits
  - Calculate statistics
- **Rule**: Only calls the Data Access Layer

### 3. Data Access Layer (`repository.py`, `models.py`)
- **Responsibility**: Abstract database operations
- **Files**: 
  - `models.py` - Define database schema
  - `repository.py` - Implement repository pattern
- **Rule**: Only interacts with the database

### 4. Database Layer (PostgreSQL)
- **Responsibility**: Store and retrieve data
- **Technology**: PostgreSQL

## 🚀 Setup Instructions

### Prerequisites
- Python 3.8+
- PostgreSQL 12+
- pip (Python package manager)

### 1. Install PostgreSQL

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
```

**macOS:**
```bash
brew install postgresql
brew services start postgresql
```

**Windows:**
Download and install from [postgresql.org](https://www.postgresql.org/download/windows/)

### 2. Create Database

```bash
# Access PostgreSQL
sudo -u postgres psql

# Create database and user
CREATE DATABASE todo_db;
CREATE USER todo_user WITH PASSWORD 'todo_password';
ALTER ROLE todo_user SET client_encoding TO 'utf8';
ALTER ROLE todo_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE todo_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE todo_db TO todo_user;
\q
```

### 3. Setup Backend

```bash
# Navigate to backend directory
cd backend

# Install Python dependencies
pip install -r requirements.txt

# Run migrations to create database tables
python manage.py makemigrations
python manage.py migrate

# Create superuser (optional, for admin panel)
python manage.py createsuperuser

# Run development server
python manage.py runserver
```

The API will be available at `http://localhost:8000/api/`

### 4. Setup Frontend

```bash
# Navigate to frontend directory
cd frontend

# Open index.html in a browser
# Or use a simple HTTP server:
python -m http.server 3000
```

The frontend will be available at `http://localhost:3000`

## 🔌 API Endpoints

### Todos
- `GET /api/todos/` - List all todos
- `POST /api/todos/` - Create a new todo
- `GET /api/todos/{id}/` - Get a specific todo
- `PUT /api/todos/{id}/` - Update a todo
- `DELETE /api/todos/{id}/` - Delete a todo
- `POST /api/todos/{id}/toggle/` - Toggle completion status

### Statistics
- `GET /api/todos/statistics/` - Get todo statistics

## 📝 Example API Usage

### Create a Todo
```bash
curl -X POST http://localhost:8000/api/todos/ \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Learn Layered Architecture",
    "description": "Understand separation of concerns",
    "completed": false
  }'
```

### Get All Todos
```bash
curl http://localhost:8000/api/todos/
```

### Toggle Todo Completion
```bash
curl -X POST http://localhost:8000/api/todos/1/toggle/
```

## 🧪 Testing the Layers

### Test Data Access Layer
```python
python manage.py shell

from todo_app.repository import TodoRepository

# Create a todo
todo = TodoRepository.create(title="Test", description="Testing repo")
print(todo.id)

# Get all todos
todos = TodoRepository.get_all()
print(len(todos))
```

### Test Business Logic Layer
```python
python manage.py shell

from todo_app.service import TodoService

service = TodoService()

# Create with validation
todo = service.create_todo({
    'title': 'Test Service',
    'description': 'Testing business logic'
})

# Get statistics
stats = service.get_statistics()
print(stats)
```

## 🎨 Key Features

- ✅ Complete separation of concerns
- ✅ Repository pattern for data access
- ✅ Service layer for business logic
- ✅ RESTful API design
- ✅ Input validation at multiple layers
- ✅ Clean and maintainable code structure
- ✅ PostgreSQL database integration
- ✅ Responsive frontend design
- ✅ Real-time statistics

## 📚 Benefits of Layered Architecture

1. **Maintainability**: Each layer has a single responsibility
2. **Testability**: Layers can be tested independently
3. **Flexibility**: Easy to change implementation in one layer
4. **Scalability**: Clear structure makes it easier to scale
5. **Reusability**: Business logic can be reused across different interfaces

## 🔧 Configuration

### Change Database Settings
Edit `backend/config/settings.py`:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'your_db_name',
        'USER': 'your_db_user',
        'PASSWORD': 'your_db_password',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
```

### Change API URL
Edit `frontend/app.js`:
```javascript
const API_BASE_URL = 'http://your-api-url:port/api';
```

## 🐛 Troubleshooting

### PostgreSQL Connection Error
- Ensure PostgreSQL is running: `sudo service postgresql status`
- Check database credentials in `settings.py`
- Verify database exists: `psql -U postgres -l`

### CORS Errors
- Backend should be running on port 8000
- Check CORS settings in `settings.py`

### Migration Errors
```bash
python manage.py makemigrations
python manage.py migrate --run-syncdb
```

## 📖 Learning Resources

- [Django Documentation](https://docs.djangoproject.com/)
- [PostgreSQL Tutorial](https://www.postgresql.org/docs/)
- [REST API Design](https://restfulapi.net/)
- [Layered Architecture Pattern](https://martinfowler.com/bliki/PresentationDomainDataLayering.html)

## 📄 License

This project is for educational purposes demonstrating layered architecture principles.

## 🤝 Contributing

Feel free to fork this project and adapt it for your learning needs!
