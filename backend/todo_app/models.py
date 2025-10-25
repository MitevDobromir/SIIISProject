"""
DATA ACCESS LAYER - Models
Defines the database schema and data structure
"""
from django.db import models


class Todo(models.Model):
    """
    Todo model representing a task in the database
    """
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True, null=True)
    completed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'todos'
        ordering = ['-created_at']

    def __str__(self):
        return self.title
