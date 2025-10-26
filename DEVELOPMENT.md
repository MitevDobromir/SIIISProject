# Development Documentation

## Architecture Overview

This application implements a four-layer architecture pattern separating concerns into distinct layers: Presentation, Business Logic, Data Access, and Database.

## Project Structure

```
backend/
├── config/
│   ├── settings.py          # Django configuration and database settings
│   ├── urls.py              # Root URL routing
│   └── wsgi.py              # WSGI application entry point
└── todo_app/
    ├── models.py            # Database schema definitions
    ├── repository.py        # Data access abstraction layer
    ├── service.py           # Business logic implementation
    ├── views.py             # HTTP request handlers
    ├── serializers.py       # Data transformation layer
    ├── urls.py              # Application URL routing
    └── admin.py             # Django admin configuration

frontend/
├── index.html               # Application user interface
├── styles.css               # UI styling definitions
└── app.js                   # API communication and DOM manipulation

docker-compose.yml           # Container orchestration configuration
Dockerfile                   # Backend container image definition
app.sh                       # Application management script
```

## Layer Architecture

### Presentation Layer

The presentation layer handles all HTTP interactions and user interface rendering. Backend views in `views.py` receive HTTP requests and delegate processing to the service layer. Serializers in `serializers.py` transform data between JSON and Python objects while validating input format. The frontend consists of vanilla JavaScript communicating with the REST API.

### Business Logic Layer

Business logic resides in `service.py` and enforces application rules. The TodoService class validates that todo titles are non-empty and under 200 characters. It orchestrates operations across repository methods and applies business constraints before data persistence. This layer has no knowledge of HTTP or database implementation details.

### Data Access Layer

The repository pattern in `repository.py` abstracts database operations. TodoRepository provides methods for CRUD operations without exposing underlying ORM implementation. The `models.py` file defines the database schema using Django ORM. This separation allows the business layer to remain database-agnostic.

### Database Layer

PostgreSQL runs in a Docker container and stores application data. The database schema includes a todos table with fields for title, description, completion status, and timestamps. Django migrations manage schema evolution.

## API Endpoints

The application exposes a RESTful API:

```
GET    /api/todos/              List all todos
POST   /api/todos/              Create new todo
GET    /api/todos/{id}/         Retrieve specific todo
PUT    /api/todos/{id}/         Update todo
DELETE /api/todos/{id}/         Delete todo
POST   /api/todos/{id}/toggle/  Toggle completion status
GET    /api/todos/statistics/   Retrieve statistics
```

## Data Flow

HTTP requests enter through `views.py` which validates input using serializers. Valid requests are passed to `service.py` where business rules are applied. The service layer calls `repository.py` methods to persist or retrieve data. The repository interacts with Django ORM models which communicate with PostgreSQL. Responses traverse back through the same layers with data serialized to JSON.

## Frontend Implementation

The frontend uses the Fetch API to communicate with the backend. JavaScript in `app.js` handles DOM manipulation and API calls. All UI state is fetched from the backend on page load and updated through API interactions. The application does not use any frontend frameworks.

## Configuration

Environment-based configuration is handled through Django settings. The database connection uses environment variables that differ between Docker and native deployments. CORS is enabled for development allowing the frontend to call the API from a different port.

## Development Workflow

Code changes to backend files trigger Django's auto-reload mechanism when running in development mode. Frontend changes require only a browser refresh. Database schema changes require migration creation using Django's migration system followed by migration application.

## Testing

The layered architecture enables independent testing of each layer. Business logic in the service layer can be tested without database connections. Repository methods can be tested with test databases. API endpoints can be tested using Django REST framework's test client.

## Database Migrations

Django manages database schema through migrations stored in `todo_app/migrations/`. Creating a migration after model changes:

```bash
docker-compose exec backend python manage.py makemigrations
```

Applying migrations to the database:

```bash
docker-compose exec backend python manage.py migrate
```

## Adding Features

New features follow the layer pattern. Add fields to models, create migrations, update repository methods, implement business logic in services, add API endpoints in views, and update serializers for data transformation. Frontend changes involve updating the JavaScript to call new endpoints.

## Code Standards

The codebase follows Django conventions and PEP 8 style guidelines. Each layer maintains clear boundaries with no circular dependencies. Business logic never directly imports models or views. Repository methods return model instances that services manipulate.
