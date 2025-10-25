# Layered Architecture Documentation

## Overview

This project demonstrates a **4-layer architecture** pattern, also known as **N-tier architecture**. This pattern separates concerns into distinct layers, each with specific responsibilities.

## The Four Layers

### 1. Presentation Layer (UI Layer)
**Location**: `views.py`, `serializers.py`, `frontend/`

**Responsibilities**:
- Handle HTTP requests and responses
- Validate input data format
- Transform data between JSON and Python objects
- Render user interface
- Handle user interactions

**Key Components**:
- **Views** (`views.py`): API endpoints that receive requests
- **Serializers** (`serializers.py`): Convert between JSON and Python objects
- **Frontend** (HTML/CSS/JS): User interface

**Example Flow**:
```python
# views.py - Presentation Layer
@api_view(['POST'])
def todo_list(request):
    serializer = TodoCreateSerializer(data=request.data)
    if serializer.is_valid():
        todo = todo_service.create_todo(serializer.validated_data)
        return Response(TodoSerializer(todo).data)
```

**Rules**:
- ✅ Can call Business Logic Layer
- ❌ Cannot directly access Data Access Layer
- ❌ Cannot contain business logic

### 2. Business Logic Layer (Service Layer)
**Location**: `service.py`

**Responsibilities**:
- Implement business rules and validation
- Orchestrate operations across multiple repositories
- Enforce business constraints
- Calculate derived data
- Make business decisions

**Key Components**:
- **TodoService**: Contains all business logic for todos

**Example Flow**:
```python
# service.py - Business Logic Layer
def create_todo(self, data: Dict[str, Any]) -> Todo:
    # Business Rule: Title is required
    title = data.get('title', '').strip()
    if not title:
        raise ValueError("Title is required")
    
    # Business Rule: Title length limit
    if len(title) > 200:
        raise ValueError("Title cannot exceed 200 characters")
    
    # Delegate to data layer
    return self.repository.create(title=title, ...)
```

**Business Rules in This Project**:
1. Title must not be empty
2. Title cannot exceed 200 characters
3. Description is optional
4. New todos are incomplete by default
5. Todo ID must be positive

**Rules**:
- ✅ Can call Data Access Layer
- ❌ Cannot directly access Database
- ❌ Should not know about HTTP, JSON, or UI concerns

### 3. Data Access Layer (Repository Layer)
**Location**: `repository.py`, `models.py`

**Responsibilities**:
- Abstract database operations
- Provide a clean API for data operations
- Handle database queries
- Define database schema

**Key Components**:
- **Models** (`models.py`): Define database structure
- **Repository** (`repository.py`): Abstract data operations

**Example Flow**:
```python
# repository.py - Data Access Layer
class TodoRepository:
    @staticmethod
    def create(title: str, description: str, completed: bool) -> Todo:
        return Todo.objects.create(
            title=title,
            description=description,
            completed=completed
        )
    
    @staticmethod
    def get_all() -> List[Todo]:
        return Todo.objects.all()
```

**Repository Pattern Benefits**:
1. **Abstraction**: Hide database implementation details
2. **Testability**: Easy to mock for unit tests
3. **Flexibility**: Can change database without affecting business logic
4. **Centralization**: All data queries in one place

**Rules**:
- ✅ Can access Database Layer
- ❌ Cannot contain business logic
- ❌ Should not know about HTTP, serializers, or UI

### 4. Database Layer
**Location**: PostgreSQL database

**Responsibilities**:
- Store and retrieve data
- Enforce data integrity
- Handle transactions
- Manage indexes and optimization

**Key Components**:
- **PostgreSQL**: Relational database management system
- **Tables**: Store actual data
- **Indexes**: Optimize queries

## Communication Flow

```
User Request
     ↓
┌─────────────────────────────────────┐
│   PRESENTATION LAYER                │
│   - Receives HTTP request           │
│   - Validates JSON format           │
│   - Serializes/deserializes data    │
└─────────────────────────────────────┘
     ↓ (calls)
┌─────────────────────────────────────┐
│   BUSINESS LOGIC LAYER              │
│   - Validates business rules        │
│   - Enforces constraints            │
│   - Makes business decisions        │
└─────────────────────────────────────┘
     ↓ (calls)
┌─────────────────────────────────────┐
│   DATA ACCESS LAYER                 │
│   - Translates to database queries  │
│   - Manages database connections    │
│   - Returns model objects           │
└─────────────────────────────────────┘
     ↓ (queries)
┌─────────────────────────────────────┐
│   DATABASE LAYER                    │
│   - Executes SQL queries            │
│   - Returns raw data                │
│   - Manages transactions            │
└─────────────────────────────────────┘
```

## Example: Creating a Todo

Let's trace a request through all layers:

### 1. Frontend sends request
```javascript
// app.js
fetch('http://localhost:8000/api/todos/', {
    method: 'POST',
    body: JSON.stringify({
        title: 'Learn Django',
        description: 'Build a REST API'
    })
})
```

### 2. Presentation Layer receives request
```python
# views.py
@api_view(['POST'])
def todo_list(request):
    # Validate JSON format
    serializer = TodoCreateSerializer(data=request.data)
    if serializer.is_valid():
        # Pass to business layer
        todo = todo_service.create_todo(serializer.validated_data)
        # Return response
        return Response(TodoSerializer(todo).data)
```

### 3. Business Logic Layer validates
```python
# service.py
def create_todo(self, data):
    # Business validation
    title = data.get('title', '').strip()
    if not title:
        raise ValueError("Title is required")
    if len(title) > 200:
        raise ValueError("Title too long")
    
    # Pass to data layer
    return self.repository.create(
        title=title,
        description=data.get('description', ''),
        completed=False
    )
```

### 4. Data Access Layer saves to database
```python
# repository.py
def create(title, description, completed):
    # Create database record
    return Todo.objects.create(
        title=title,
        description=description,
        completed=completed
    )
```

### 5. Database Layer stores data
```sql
-- Generated SQL
INSERT INTO todos (title, description, completed, created_at, updated_at)
VALUES ('Learn Django', 'Build a REST API', false, NOW(), NOW())
RETURNING id;
```

## Benefits of This Architecture

### 1. Separation of Concerns
Each layer has a single, well-defined responsibility. You know exactly where to look for specific functionality.

### 2. Maintainability
Changes in one layer don't affect others. For example:
- Change from PostgreSQL to MySQL? Only touch Data Access Layer
- Change API format? Only touch Presentation Layer
- Add new business rule? Only touch Business Logic Layer

### 3. Testability
Each layer can be tested independently:
```python
# Test Business Layer without database
def test_create_todo_validation():
    service = TodoService()
    with pytest.raises(ValueError):
        service.create_todo({'title': ''})  # Should fail
```

### 4. Reusability
Business logic can be used by multiple interfaces:
- REST API
- GraphQL API
- Command-line interface
- Scheduled tasks

All use the same business logic layer!

### 5. Team Collaboration
Different team members can work on different layers simultaneously without conflicts.

## Anti-Patterns to Avoid

### ❌ Skipping Layers
```python
# BAD: View directly accessing database
@api_view(['POST'])
def todo_list(request):
    todo = Todo.objects.create(title=request.data['title'])  # Skip business layer!
    return Response(...)
```

### ❌ Business Logic in Presentation Layer
```python
# BAD: Validation in views
@api_view(['POST'])
def todo_list(request):
    if len(request.data['title']) > 200:  # Business logic in presentation!
        return Response({'error': 'Title too long'})
```

### ❌ Business Logic in Data Access Layer
```python
# BAD: Validation in repository
def create(title, description):
    if not title:  # Business logic in data layer!
        raise ValueError("Title required")
    return Todo.objects.create(...)
```

## When to Use Layered Architecture

### ✅ Good For:
- Medium to large applications
- Applications with complex business logic
- Projects requiring high maintainability
- Teams with multiple developers
- Applications that may change databases/frameworks

### ❌ Overkill For:
- Very simple CRUD applications
- Prototypes or proof-of-concepts
- Single-developer projects with simple logic

## Comparison with Other Patterns

### Layered vs MVC
- **MVC**: Model-View-Controller (focused on UI separation)
- **Layered**: Separates entire application stack (including business logic)
- **Use case**: Layered is better for complex business logic

### Layered vs Microservices
- **Layered**: All layers in one application
- **Microservices**: Each service is independently deployable
- **Use case**: Start with layered, evolve to microservices if needed

### Layered vs Hexagonal
- **Layered**: Top-down dependency flow
- **Hexagonal**: Center-out with ports/adapters
- **Use case**: Hexagonal is more flexible but more complex

## Further Reading

- [Martin Fowler - Presentation Domain Data Layering](https://martinfowler.com/bliki/PresentationDomainDataLayering.html)
- [Microsoft - N-tier Architecture](https://docs.microsoft.com/en-us/azure/architecture/guide/architecture-styles/n-tier)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
- [Domain-Driven Design](https://martinfowler.com/tags/domain%20driven%20design.html)
