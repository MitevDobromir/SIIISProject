# 🚀 Complete Setup Guide - New Structure

The setup has been restructured into clear, modular scripts for easier use!

---

## 📋 Script Overview

| Script | Purpose | Run Once/Multiple |
|--------|---------|-------------------|
| `setup_dependencies` | Install system dependencies (Docker, Python, etc.) | Once per machine |
| `setup_docker` | Build Docker containers | Once per project |
| `run_docker` | Start the application | Every time you want to run |

---

## 🐧 **Linux/macOS Setup**

### Step 1: Install Dependencies
```bash
chmod +x setup_dependencies.sh
./setup_dependencies.sh
```

**What it does:**
- ✅ Installs Docker & Docker Compose
- ✅ Installs Python & Git
- ✅ Starts Docker service
- ✅ Adds you to docker group
- ✅ Optionally installs PostgreSQL

**Run this:** Once per machine

---

### Step 2: Build Containers
```bash
./setup_docker.sh
```

**What it does:**
- ✅ Checks Docker is installed
- ✅ Builds application containers
- ✅ Creates .env configuration file

**Run this:** Once per project (or after changing Dockerfile)

---

### Step 3: Start Application
```bash
./run_docker.sh
```

**What it does:**
- ✅ Starts all containers
- ✅ Runs database migrations
- ✅ Shows you where to access the app

**Run this:** Every time you want to start the application

---

### Access Your Application:
- **Backend API:** http://localhost:8000
- **API Docs:** http://localhost:8000/api/todos/
- **Admin Panel:** http://localhost:8000/admin
- **Frontend:** Open `frontend/index.html` in your browser

---

## 🪟 **Windows Setup**

### Step 1: Install Dependencies
```powershell
# Run PowerShell as Administrator
.\setup_dependencies.ps1
```

**What it does:**
- ✅ Installs Docker Desktop via winget
- ✅ Installs Python via winget
- ✅ Installs Git via winget
- ✅ Optionally installs PostgreSQL

**Run this:** Once per machine

---

### Step 2: Build Containers
```powershell
.\setup_docker.ps1
```

**What it does:**
- ✅ Checks Docker is running
- ✅ Builds application containers
- ✅ Creates .env configuration file

**Run this:** Once per project

---

### Step 3: Start Application
```powershell
.\run_docker.ps1
```

**What it does:**
- ✅ Starts all containers
- ✅ Shows you where to access the app

**Run this:** Every time you want to start

---

## 🎯 **Quick Start (TL;DR)**

### First Time Setup:
```bash
# Linux/Mac
./setup_dependencies.sh
./setup_docker.sh
./run_docker.sh

# Windows (PowerShell as Admin)
.\setup_dependencies.ps1
.\setup_docker.ps1
.\run_docker.ps1
```

### Subsequent Runs:
```bash
# Linux/Mac
./run_docker.sh

# Windows
.\run_docker.ps1
```

---

## 🔧 **Common Commands**

### View Logs:
```bash
docker-compose logs -f
```

### Stop Application:
```bash
docker-compose down
```

### Restart After Code Changes:
```bash
docker-compose restart backend
```

### Create Admin User:
```bash
docker-compose exec backend python manage.py createsuperuser
```

### Rebuild After Dependency Changes:
```bash
./setup_docker.sh  # Rebuild
./run_docker.sh    # Start
```

---

## 📁 **File Structure**

```
todo_project/
├── setup_dependencies.sh    # 1️⃣ Install system dependencies
├── setup_dependencies.ps1   # 1️⃣ (Windows version)
├── setup_docker.sh          # 2️⃣ Build Docker containers
├── setup_docker.ps1         # 2️⃣ (Windows version)
├── run_docker.sh            # 3️⃣ Start application
├── run_docker.ps1           # 3️⃣ (Windows version)
├── docker-compose.yml       # Docker services config
├── Dockerfile               # Container definition
├── backend/                 # Django application
├── frontend/                # HTML/CSS/JS
└── ...
```

---

## 🎓 **When to Run Each Script**

### `setup_dependencies` - Run When:
- ✅ First time setting up on a new machine
- ✅ Docker is not installed
- ✅ Need to update Docker

### `setup_docker` - Run When:
- ✅ First time with project
- ✅ Changed Dockerfile
- ✅ Changed docker-compose.yml
- ✅ Added new Python dependencies to requirements.txt

### `run_docker` - Run When:
- ✅ Want to start the application
- ✅ After rebooting your machine
- ✅ After running `docker-compose down`

---

## 🐛 **Troubleshooting**

### "Docker not found" Error:
```bash
# Make sure you ran setup_dependencies first
./setup_dependencies.sh

# On Linux, you may need to activate docker group
newgrp docker
```

### "Permission denied" Error:
```bash
# Make scripts executable
chmod +x *.sh

# Or run with bash
bash setup_dependencies.sh
```

### "Containers not built" Error:
```bash
# Run setup_docker first
./setup_docker.sh
```

### Port 8000 Already in Use:
```bash
# Stop other containers
docker-compose down

# Or change port in docker-compose.yml
```

### Changes Not Reflecting:
```bash
# For code changes
docker-compose restart backend

# For dependency changes
./setup_docker.sh
./run_docker.sh
```

---

## 💡 **Benefits of This Structure**

### ✅ Clear Separation:
- Dependencies installation separate from container setup
- Easy to run app without reinstalling dependencies

### ✅ Modular:
- Only run what you need
- Skip steps that are already done

### ✅ Easy to Understand:
- Script names clearly indicate purpose
- Numbered workflow (1 → 2 → 3)

### ✅ Cross-Platform:
- Linux/Mac (.sh files)
- Windows (.ps1 files)
- Same workflow on all platforms

---

## 🎯 **For New Users (Complete Workflow)**

### Day 1 - Initial Setup:
```bash
# 1. Clone the repository
git clone https://github.com/MitevDobromir/SIIISProject.git
cd SIIISProject

# 2. Install dependencies (once per machine)
./setup_dependencies.sh

# 3. Build containers (once per project)
./setup_docker.sh

# 4. Start application
./run_docker.sh

# 5. Open frontend/index.html in browser
```

### Day 2+ - Just Run:
```bash
# Start the application
./run_docker.sh

# That's it! 🎉
```

---

## 📊 **Comparison with Old Approach**

| Old Approach | New Approach |
|--------------|--------------|
| One massive script | 3 focused scripts |
| Reinstalls everything | Only install once |
| Hard to debug | Clear steps |
| Mixed concerns | Separated concerns |

---

## 🚀 **Next Steps**

After running `./run_docker.sh`:

1. **Test the API:**
   ```bash
   curl http://localhost:8000/api/todos/
   ```

2. **Create Admin User:**
   ```bash
   docker-compose exec backend python manage.py createsuperuser
   ```

3. **Access Admin Panel:**
   http://localhost:8000/admin

4. **Open Frontend:**
   Open `frontend/index.html` in your browser

5. **Start Building!** 🎉

---

## 📖 **Additional Documentation**

- **Docker Details:** See `DOCKER_SETUP.md`
- **Architecture:** See `ARCHITECTURE.md`
- **Quick Start:** See `QUICKSTART.md`
- **Full README:** See `README.md`

---

**Enjoy your clean, modular setup! 🎉**
