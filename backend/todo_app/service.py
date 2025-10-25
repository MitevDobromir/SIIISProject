"""
BUSINESS LOGIC LAYER - Services
Contains business rules and operations
"""
from typing import List, Optional, Dict, Any
from .repository import TodoRepository
from .models import Todo


class TodoService:
    """
    Service class containing business logic for Todo operations
    Acts as an intermediary between the presentation layer and data access layer
    """
    
    def __init__(self):
        self.repository = TodoRepository()
    
    def get_all_todos(self) -> List[Todo]:
        """
        Get all todos
        Business rule: Returns all todos ordered by creation date
        """
        return self.repository.get_all()
    
    def get_todo_by_id(self, todo_id: int) -> Optional[Todo]:
        """
        Get a specific todo by ID
        Business rule: Validates todo_id is positive
        """
        if todo_id <= 0:
            raise ValueError("Todo ID must be a positive integer")
        return self.repository.get_by_id(todo_id)
    
    def create_todo(self, data: Dict[str, Any]) -> Todo:
        """
        Create a new todo
        Business rules:
        - Title is required and must not be empty
        - Description is optional
        - New todos are incomplete by default
        """
        title = data.get('title', '').strip()
        
        if not title:
            raise ValueError("Title is required and cannot be empty")
        
        if len(title) > 200:
            raise ValueError("Title cannot exceed 200 characters")
        
        description = data.get('description', '').strip()
        completed = data.get('completed', False)
        
        return self.repository.create(
            title=title,
            description=description,
            completed=completed
        )
    
    def update_todo(self, todo_id: int, data: Dict[str, Any]) -> Optional[Todo]:
        """
        Update an existing todo
        Business rules:
        - Todo must exist
        - Title must not be empty if provided
        """
        todo = self.repository.get_by_id(todo_id)
        
        if not todo:
            return None
        
        update_data = {}
        
        if 'title' in data:
            title = data['title'].strip()
            if not title:
                raise ValueError("Title cannot be empty")
            if len(title) > 200:
                raise ValueError("Title cannot exceed 200 characters")
            update_data['title'] = title
        
        if 'description' in data:
            update_data['description'] = data['description'].strip()
        
        if 'completed' in data:
            update_data['completed'] = data['completed']
        
        return self.repository.update(todo, **update_data)
    
    def delete_todo(self, todo_id: int) -> bool:
        """
        Delete a todo
        Business rule: Todo must exist to be deleted
        """
        todo = self.repository.get_by_id(todo_id)
        
        if not todo:
            return False
        
        self.repository.delete(todo)
        return True
    
    def toggle_completion(self, todo_id: int) -> Optional[Todo]:
        """
        Toggle the completion status of a todo
        Business rule: Flips the completed status
        """
        todo = self.repository.get_by_id(todo_id)
        
        if not todo:
            return None
        
        return self.repository.update(todo, completed=not todo.completed)
    
    def get_statistics(self) -> Dict[str, int]:
        """
        Get todo statistics
        Business rule: Provides overview of todo status
        """
        all_todos = self.repository.get_all()
        completed = self.repository.get_completed()
        incomplete = self.repository.get_incomplete()
        
        return {
            'total': len(all_todos),
            'completed': len(completed),
            'incomplete': len(incomplete)
        }
