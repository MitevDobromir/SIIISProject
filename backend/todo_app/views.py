"""
PRESENTATION LAYER - Views/Controllers
Handles HTTP requests and responses
"""
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .service import TodoService
from .serializers import TodoSerializer, TodoCreateSerializer, TodoUpdateSerializer


# Initialize service
todo_service = TodoService()


@api_view(['GET', 'POST'])
def todo_list(request):
    """
    GET: List all todos
    POST: Create a new todo
    """
    
    if request.method == 'GET':
        # Retrieve all todos through service layer
        todos = todo_service.get_all_todos()
        serializer = TodoSerializer(todos, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        # Create new todo through service layer
        serializer = TodoCreateSerializer(data=request.data)
        
        if serializer.is_valid():
            try:
                todo = todo_service.create_todo(serializer.validated_data)
                response_serializer = TodoSerializer(todo)
                return Response(
                    response_serializer.data,
                    status=status.HTTP_201_CREATED
                )
            except ValueError as e:
                return Response(
                    {'error': str(e)},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def todo_detail(request, pk):
    """
    GET: Retrieve a specific todo
    PUT: Update a todo
    DELETE: Delete a todo
    """
    
    if request.method == 'GET':
        # Retrieve specific todo through service layer
        try:
            todo = todo_service.get_todo_by_id(pk)
            if not todo:
                return Response(
                    {'error': 'Todo not found'},
                    status=status.HTTP_404_NOT_FOUND
                )
            serializer = TodoSerializer(todo)
            return Response(serializer.data)
        except ValueError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
    
    elif request.method == 'PUT':
        # Update todo through service layer
        serializer = TodoUpdateSerializer(data=request.data)
        
        if serializer.is_valid():
            try:
                todo = todo_service.update_todo(pk, serializer.validated_data)
                if not todo:
                    return Response(
                        {'error': 'Todo not found'},
                        status=status.HTTP_404_NOT_FOUND
                    )
                response_serializer = TodoSerializer(todo)
                return Response(response_serializer.data)
            except ValueError as e:
                return Response(
                    {'error': str(e)},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        # Delete todo through service layer
        success = todo_service.delete_todo(pk)
        if not success:
            return Response(
                {'error': 'Todo not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['POST'])
def todo_toggle(request, pk):
    """
    POST: Toggle completion status of a todo
    """
    todo = todo_service.toggle_completion(pk)
    
    if not todo:
        return Response(
            {'error': 'Todo not found'},
            status=status.HTTP_404_NOT_FOUND
        )
    
    serializer = TodoSerializer(todo)
    return Response(serializer.data)


@api_view(['GET'])
def todo_statistics(request):
    """
    GET: Get todo statistics
    """
    stats = todo_service.get_statistics()
    return Response(stats)
