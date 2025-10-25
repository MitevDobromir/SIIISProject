"""
DATA ACCESS LAYER - Repository Pattern
Provides an abstraction layer for data access operations
"""
from typing import List, Optional
from .models import Todo


class TodoRepository:
    """
    Repository class that handles all database operations for Todo model
    Separates data access logic from business logic
    """
    
    @staticmethod
    def get_all() -> List[Todo]:
        """Retrieve all todos from database"""
        return Todo.objects.all()
    
    @staticmethod
    def get_by_id(todo_id: int) -> Optional[Todo]:
        """Retrieve a specific todo by ID"""
        try:
            return Todo.objects.get(id=todo_id)
        except Todo.DoesNotExist:
            return None
    
    @staticmethod
    def create(title: str, description: str = "", completed: bool = False) -> Todo:
        """Create a new todo in the database"""
        return Todo.objects.create(
            title=title,
            description=description,
            completed=completed
        )
    
    @staticmethod
    def update(todo: Todo, **kwargs) -> Todo:
        """Update an existing todo"""
        for key, value in kwargs.items():
            setattr(todo, key, value)
        todo.save()
        return todo
    
    @staticmethod
    def delete(todo: Todo) -> None:
        """Delete a todo from the database"""
        todo.delete()
    
    @staticmethod
    def get_completed() -> List[Todo]:
        """Get all completed todos"""
        return Todo.objects.filter(completed=True)
    
    @staticmethod
    def get_incomplete() -> List[Todo]:
        """Get all incomplete todos"""
        return Todo.objects.filter(completed=False)
