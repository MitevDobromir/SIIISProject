"""
URL routing for todo_app
"""
from django.urls import path
from . import views

urlpatterns = [
    path('todos/', views.todo_list, name='todo-list'),
    path('todos/<int:pk>/', views.todo_detail, name='todo-detail'),
    path('todos/<int:pk>/toggle/', views.todo_toggle, name='todo-toggle'),
    path('todos/statistics/', views.todo_statistics, name='todo-statistics'),
]
