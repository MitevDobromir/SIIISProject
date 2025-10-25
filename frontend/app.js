// Configuration
const API_BASE_URL = 'http://localhost:8000/api';

// DOM Elements
const addTodoForm = document.getElementById('add-todo-form');
const todoTitleInput = document.getElementById('todo-title');
const todoDescriptionInput = document.getElementById('todo-description');
const todoList = document.getElementById('todo-list');
const emptyState = document.getElementById('empty-state');
const totalCount = document.getElementById('total-count');
const completedCount = document.getElementById('completed-count');
const incompleteCount = document.getElementById('incomplete-count');

// Initialize app
document.addEventListener('DOMContentLoaded', () => {
    loadTodos();
    loadStatistics();
});

// Event Listeners
addTodoForm.addEventListener('submit', handleAddTodo);

// API Functions
async function loadTodos() {
    try {
        const response = await fetch(`${API_BASE_URL}/todos/`);
        
        if (!response.ok) {
            throw new Error('Failed to fetch todos');
        }
        
        const todos = await response.json();
        renderTodos(todos);
    } catch (error) {
        console.error('Error loading todos:', error);
        showError('Failed to load tasks. Make sure the backend server is running.');
    }
}

async function loadStatistics() {
    try {
        const response = await fetch(`${API_BASE_URL}/todos/statistics/`);
        
        if (!response.ok) {
            throw new Error('Failed to fetch statistics');
        }
        
        const stats = await response.json();
        updateStatistics(stats);
    } catch (error) {
        console.error('Error loading statistics:', error);
    }
}

async function createTodo(todoData) {
    try {
        const response = await fetch(`${API_BASE_URL}/todos/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(todoData)
        });
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.error || 'Failed to create todo');
        }
        
        return await response.json();
    } catch (error) {
        console.error('Error creating todo:', error);
        throw error;
    }
}

async function toggleTodo(todoId) {
    try {
        const response = await fetch(`${API_BASE_URL}/todos/${todoId}/toggle/`, {
            method: 'POST',
        });
        
        if (!response.ok) {
            throw new Error('Failed to toggle todo');
        }
        
        return await response.json();
    } catch (error) {
        console.error('Error toggling todo:', error);
        throw error;
    }
}

async function deleteTodo(todoId) {
    try {
        const response = await fetch(`${API_BASE_URL}/todos/${todoId}/`, {
            method: 'DELETE',
        });
        
        if (!response.ok) {
            throw new Error('Failed to delete todo');
        }
        
        return true;
    } catch (error) {
        console.error('Error deleting todo:', error);
        throw error;
    }
}

// Event Handlers
async function handleAddTodo(event) {
    event.preventDefault();
    
    const title = todoTitleInput.value.trim();
    const description = todoDescriptionInput.value.trim();
    
    if (!title) {
        alert('Please enter a task title');
        return;
    }
    
    try {
        await createTodo({
            title,
            description,
            completed: false
        });
        
        // Reset form
        todoTitleInput.value = '';
        todoDescriptionInput.value = '';
        
        // Reload todos and statistics
        await loadTodos();
        await loadStatistics();
    } catch (error) {
        alert(error.message || 'Failed to create task');
    }
}

async function handleToggleTodo(todoId) {
    try {
        await toggleTodo(todoId);
        await loadTodos();
        await loadStatistics();
    } catch (error) {
        alert('Failed to update task');
    }
}

async function handleDeleteTodo(todoId) {
    if (!confirm('Are you sure you want to delete this task?')) {
        return;
    }
    
    try {
        await deleteTodo(todoId);
        await loadTodos();
        await loadStatistics();
    } catch (error) {
        alert('Failed to delete task');
    }
}

// Rendering Functions
function renderTodos(todos) {
    if (todos.length === 0) {
        todoList.classList.remove('visible');
        emptyState.classList.remove('hidden');
        return;
    }
    
    todoList.classList.add('visible');
    emptyState.classList.add('hidden');
    
    todoList.innerHTML = todos.map(todo => createTodoElement(todo)).join('');
    
    // Add event listeners to buttons
    todos.forEach(todo => {
        const toggleBtn = document.getElementById(`toggle-${todo.id}`);
        const deleteBtn = document.getElementById(`delete-${todo.id}`);
        
        if (toggleBtn) {
            toggleBtn.addEventListener('click', () => handleToggleTodo(todo.id));
        }
        
        if (deleteBtn) {
            deleteBtn.addEventListener('click', () => handleDeleteTodo(todo.id));
        }
    });
}

function createTodoElement(todo) {
    const date = new Date(todo.created_at).toLocaleDateString();
    const completedClass = todo.completed ? 'completed' : '';
    
    return `
        <div class="todo-item ${completedClass}">
            <div class="todo-header">
                <div class="todo-title">${escapeHtml(todo.title)}</div>
            </div>
            ${todo.description ? `<div class="todo-description">${escapeHtml(todo.description)}</div>` : ''}
            <div class="todo-meta">
                <div class="todo-date">Created: ${date}</div>
                <div class="todo-actions">
                    <button 
                        id="toggle-${todo.id}" 
                        class="btn ${todo.completed ? 'btn-success' : 'btn-primary'}"
                    >
                        ${todo.completed ? '✓ Completed' : 'Mark Complete'}
                    </button>
                    <button 
                        id="delete-${todo.id}" 
                        class="btn btn-danger"
                    >
                        Delete
                    </button>
                </div>
            </div>
        </div>
    `;
}

function updateStatistics(stats) {
    totalCount.textContent = stats.total;
    completedCount.textContent = stats.completed;
    incompleteCount.textContent = stats.incomplete;
}

function showError(message) {
    todoList.innerHTML = `
        <div style="text-align: center; padding: 40px; color: #ef4444;">
            <h3>⚠️ Error</h3>
            <p>${message}</p>
            <p style="margin-top: 10px; font-size: 0.9rem; color: #6b7280;">
                Make sure to:
                <br>1. Install dependencies: pip install -r requirements.txt
                <br>2. Setup database: python manage.py migrate
                <br>3. Run server: python manage.py runserver
            </p>
        </div>
    `;
}

// Utility Functions
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
