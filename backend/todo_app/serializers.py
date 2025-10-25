"""
PRESENTATION LAYER - Serializers
Transforms data between JSON and Python objects
"""
from rest_framework import serializers
from .models import Todo


class TodoSerializer(serializers.ModelSerializer):
    """
    Serializer for Todo model
    Handles conversion between Todo model instances and JSON
    """
    
    class Meta:
        model = Todo
        fields = ['id', 'title', 'description', 'completed', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def validate_title(self, value):
        """Validate title field"""
        if not value or not value.strip():
            raise serializers.ValidationError("Title cannot be empty")
        if len(value) > 200:
            raise serializers.ValidationError("Title cannot exceed 200 characters")
        return value.strip()


class TodoCreateSerializer(serializers.Serializer):
    """Serializer for creating a new todo"""
    title = serializers.CharField(max_length=200, required=True)
    description = serializers.CharField(required=False, allow_blank=True)
    completed = serializers.BooleanField(default=False)


class TodoUpdateSerializer(serializers.Serializer):
    """Serializer for updating a todo"""
    title = serializers.CharField(max_length=200, required=False)
    description = serializers.CharField(required=False, allow_blank=True)
    completed = serializers.BooleanField(required=False)
