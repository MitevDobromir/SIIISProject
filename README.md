# Todo Application - Layered Architecture

## Platform Support

This setup process is currently supported on Linux systems only. The automation scripts use shell scripting and Linux-specific package managers.

## Environment Setup

Execute the following scripts in order to prepare your development environment.

### Install Dependencies

```bash
chmod +x setup_dependencies.sh
./setup_dependencies.sh
```

This script detects your Linux distribution and installs required system packages including Docker, Docker Compose, Python 3, pip, and Git. It configures Docker service and adds your user to the docker group for permission management.

### Build Containers

```bash
chmod +x setup_docker.sh
./setup_docker.sh
```

This script builds the Docker containers defined in the project. It pulls the PostgreSQL image and builds the Django backend image with all Python dependencies.

### Start Application

```bash
chmod +x app.sh
./app.sh build    # First time only
./app.sh start
```

This script manages the application lifecycle. It orchestrates Docker Compose operations for backend and database containers while simultaneously starting the frontend HTTP server on port 3000.

## Access Points

After running the setup scripts, the application will be accessible at the following endpoints:

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- Admin Panel: http://localhost:8000/admin

## Verification

Confirm the environment is correctly configured:

```bash
./app.sh status
```

This displays the running status of all services including Docker containers and the frontend server.

## Daily Usage

For regular development work:

```bash
./app.sh start    # Begin working
./app.sh stop     # End session
./app.sh logs     # View application logs
```

## Troubleshooting

If services fail to start, rebuild the containers:

```bash
./app.sh stop
./app.sh build
./app.sh start
```

For permission issues with Docker, ensure your user was added to the docker group and log out then log back in, or execute:

```bash
newgrp docker
```

## Additional Documentation

See DEVELOPMENT.md for information about the source code architecture and structure.
