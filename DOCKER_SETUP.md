# 🐳 Docker Setup - Zero Configuration Required!

The **easiest way** to run this project - no PostgreSQL installation needed!

## ✅ Prerequisites

Only **Docker** is required:
- **Linux/Mac**: Install Docker Desktop or Docker Engine
- **Windows**: Install Docker Desktop

[Download Docker](https://www.docker.com/get-started)

---

## 🚀 Quick Start (3 Commands!)

```bash
# 1. Clone the repository
git clone https://github.com/MitevDobromir/SIIISProject.git
cd SIIISProject

# 2. Start everything with Docker
docker-compose up

# 3. Open your browser
# Backend: http://localhost:8000
# Frontend: Open frontend/index.html
```

**That's it!** Docker automatically:
- ✅ Downloads PostgreSQL
- ✅ Creates the database
- ✅ Installs Python dependencies
- ✅ Runs migrations
- ✅ Starts the backend server

---

## 📋 Common Commands

### Start the application:
```bash
docker-compose up
```

### Start in background (detached mode):
```bash
docker-compose up -d
```

### Stop the application:
```bash
docker-compose down
```

### View logs:
```bash
docker-compose logs -f
```

### Restart after code changes:
```bash
docker-compose restart backend
```

### Rebuild after dependency changes:
```bash
docker-compose up --build
```

### Create admin user:
```bash
docker-compose exec backend python manage.py createsuperuser
```

### Run migrations manually:
```bash
docker-compose exec backend python manage.py migrate
```

### Access Django shell:
```bash
docker-compose exec backend python manage.py shell
```

### Access PostgreSQL database:
```bash
docker-compose exec db psql -U todo_user -d todo_db
```

---

## 🗑️ Clean Up

### Remove containers and volumes:
```bash
docker-compose down -v
```

### Remove everything (including images):
```bash
docker-compose down -v --rmi all
```

---

## 🔧 Configuration

### Environment Variables

Edit `docker-compose.yml` to change database settings:

```yaml
environment:
  - POSTGRES_DB=your_db_name
  - POSTGRES_USER=your_username
  - POSTGRES_PASSWORD=your_password
```

### Ports

Default ports:
- **Backend**: 8000
- **Database**: 5432

Change in `docker-compose.yml`:
```yaml
ports:
  - "YOUR_PORT:8000"  # Backend
  - "YOUR_PORT:5432"  # Database
```

---

## 🐛 Troubleshooting

### Port already in use:
```bash
# Find what's using port 8000
sudo lsof -i :8000

# Kill the process or change the port in docker-compose.yml
```

### Database connection issues:
```bash
# Check if containers are running
docker-compose ps

# Restart the database
docker-compose restart db

# Check database logs
docker-compose logs db
```

### Changes not reflecting:
```bash
# Rebuild the container
docker-compose up --build

# Or force recreate
docker-compose up --force-recreate
```

### Permission issues:
```bash
# On Linux, may need to run with sudo
sudo docker-compose up

# Or add user to docker group
sudo usermod -aG docker $USER
# Then logout and login again
```

---

## 📁 File Structure

```
.
├── docker-compose.yml    # Docker services configuration
├── Dockerfile           # Backend container definition
├── backend/             # Django application
│   ├── manage.py
│   └── ...
└── frontend/            # Frontend files
    └── index.html
```

---

## 🎯 Development Workflow

1. **Make code changes** in `backend/` or `frontend/`
2. **Backend changes**: Restart with `docker-compose restart backend`
3. **Frontend changes**: Just refresh your browser
4. **Dependency changes**: Rebuild with `docker-compose up --build`

---

## 🚢 Production Deployment

For production, update:

1. **Security settings** in `backend/config/settings.py`:
   ```python
   DEBUG = False
   ALLOWED_HOSTS = ['your-domain.com']
   SECRET_KEY = 'your-production-secret-key'
   ```

2. **Use production database** credentials in `docker-compose.yml`

3. **Add nginx** for serving static files:
   ```yaml
   nginx:
     image: nginx:alpine
     ports:
       - "80:80"
     volumes:
       - ./nginx.conf:/etc/nginx/nginx.conf
   ```

---

## 💡 Why Docker?

### Advantages:
- ✅ **No manual setup** - Everything automated
- ✅ **Consistent environment** - Works the same everywhere
- ✅ **Isolated** - Won't affect your system
- ✅ **Easy cleanup** - Remove everything with one command
- ✅ **Team friendly** - Everyone has the same setup

### Perfect for:
- Quick testing
- Development
- Team collaboration
- CI/CD pipelines
- Demonstrations

---

## 🔄 Alternative: Manual Setup

If you prefer to install PostgreSQL manually, see:
- **Linux/Mac**: `./setup_all.sh`
- **Windows**: `.\setup_windows.ps1`

---

**Enjoy zero-configuration development! 🎉**
