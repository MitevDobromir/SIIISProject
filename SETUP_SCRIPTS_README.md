# 🚀 Complete Automated Setup Scripts

Two powerful setup scripts that automatically install everything you need!

## 📋 What These Scripts Do

Both scripts automatically:
1. ✅ Detect your operating system
2. ✅ Install PostgreSQL database
3. ✅ Install Python and dependencies
4. ✅ Create the database and user
5. ✅ Install Python packages (Django, etc.)
6. ✅ Run database migrations
7. ✅ Optionally create admin user
8. ✅ Start the backend server

---

## 🐧 **For Linux/macOS: `setup_all.sh`**

### Supported Systems:
- ✅ **Arch Linux** (pacman)
- ✅ **Debian/Ubuntu** (apt)
- ✅ **Fedora/RHEL/CentOS** (dnf)
- ✅ **macOS** (homebrew)

### Usage:

```bash
# Make it executable
chmod +x setup_all.sh

# Run the script
./setup_all.sh
```

### What It Does:
1. Detects your Linux distribution
2. Installs PostgreSQL + development libraries
3. Installs Python 3 + pip
4. Starts PostgreSQL service
5. Creates `todo_db` database
6. Creates `todo_user` with password `todo_password`
7. Installs all Python dependencies
8. Runs Django migrations
9. Asks if you want to create admin user
10. Optionally starts the backend server

---

## 🪟 **For Windows: `setup_windows.ps1`**

### Requirements:
- Windows 10/11
- PowerShell (built-in)
- **Run as Administrator**

### Usage:

```powershell
# Right-click PowerShell and select "Run as Administrator"
# Navigate to the project folder
cd path\to\todo_project_git

# Run the script
.\setup_windows.ps1
```

### What It Does:
1. Checks for winget (Windows Package Manager)
2. Installs PostgreSQL via winget
3. Installs Python 3.11 via winget
4. Creates PostgreSQL database
5. Installs Python dependencies
6. Runs Django migrations
7. Asks if you want to create admin user
8. Optionally starts the backend server

---

## 🎯 **Quick Start - Choose Your OS**

### Arch Linux:
```bash
./setup_all.sh
```

### Ubuntu/Debian:
```bash
./setup_all.sh
```

### Fedora/RHEL:
```bash
./setup_all.sh
```

### macOS:
```bash
./setup_all.sh
```

### Windows:
```powershell
# As Administrator
.\setup_windows.ps1
```

---

## 📝 **After Setup Completes**

### Start Backend (if not started automatically):
```bash
cd backend
python manage.py runserver
# or python3 manage.py runserver on Linux/Mac
```

Backend at: **http://localhost:8000**

### Start Frontend:

**Option 1 - Direct:**
Just open `frontend/index.html` in your browser

**Option 2 - HTTP Server:**
```bash
cd frontend
python -m http.server 3000
```

Frontend at: **http://localhost:3000**

---

## 🔧 **Configuration**

### Database Credentials (Default):
- **Database:** `todo_db`
- **User:** `todo_user`
- **Password:** `todo_password`
- **Host:** `localhost`
- **Port:** `5432`

### Change Database Settings:
Edit `backend/config/settings.py`:
```python
DATABASES = {
    'default': {
        'NAME': 'your_db_name',
        'USER': 'your_db_user',
        'PASSWORD': 'your_password',
        # ...
    }
}
```

---

## 🐛 **Troubleshooting**

### Script Fails on Linux:
```bash
# Make sure you have sudo access
sudo -v

# Try running with explicit bash
bash setup_all.sh
```

### Script Fails on Windows:
```powershell
# Make sure you're running as Administrator
# Check execution policy:
Get-ExecutionPolicy

# If restricted, allow scripts:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### PostgreSQL Already Running:
```bash
# Linux
sudo systemctl status postgresql

# Stop if needed:
sudo systemctl stop postgresql

# Start:
sudo systemctl start postgresql
```

### Database Already Exists:
The scripts handle this gracefully and continue. If you want to start fresh:
```bash
# Drop and recreate
sudo -u postgres psql -c "DROP DATABASE todo_db;"
./setup_all.sh
```

### Python Dependencies Fail:
```bash
# Manual installation
cd backend
pip install Django==4.2.7
pip install psycopg2-binary
pip install django-cors-headers
pip install djangorestframework
```

---

## ✨ **Features of These Scripts**

### Smart OS Detection:
- Automatically detects your operating system
- Uses the correct package manager
- Installs appropriate dependencies

### Error Handling:
- Continues if packages already installed
- Checks for existing services
- Provides helpful error messages

### Interactive:
- Asks before creating admin user
- Asks before starting server
- Colorful output for easy reading

### Complete Automation:
- One command does everything
- No manual steps required
- Ready to use in minutes

---

## 📚 **Manual Setup (If Scripts Fail)**

### 1. Install PostgreSQL:
- **Arch:** `sudo pacman -S postgresql`
- **Ubuntu:** `sudo apt install postgresql`
- **Windows:** Download from postgresql.org

### 2. Create Database:
```sql
CREATE DATABASE todo_db;
CREATE USER todo_user WITH PASSWORD 'todo_password';
GRANT ALL PRIVILEGES ON DATABASE todo_db TO todo_user;
```

### 3. Install Python Dependencies:
```bash
cd backend
pip install -r requirements.txt
```

### 4. Run Migrations:
```bash
python manage.py migrate
```

### 5. Start Server:
```bash
python manage.py runserver
```

---

## 🎓 **What You'll Learn**

These scripts demonstrate:
- Cross-platform shell scripting
- OS detection and handling
- Package manager automation
- Service management
- Database setup automation
- Python virtual environment handling

---

## 💡 **Tips**

1. **First Time Setup:** Let the script create the admin user
2. **Development:** Start backend first, then frontend
3. **Testing:** Use http://localhost:8000/admin to access Django admin
4. **Production:** Change database credentials in settings.py

---

## 🆘 **Need Help?**

If the automated scripts don't work:
1. Check the error messages (they're designed to be helpful!)
2. Try the manual setup steps above
3. Make sure PostgreSQL is installed and running
4. Verify Python 3.8+ is installed: `python --version`

---

**Enjoy your automated setup! 🚀**
