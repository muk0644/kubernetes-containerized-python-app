# Python Docker Application - Project Guide

## 📋 Project Description

This is a simple Python application containerized with Docker that generates random numbers using **NumPy** and prints them with the current date and time every 5 seconds. It demonstrates Docker fundamentals including:
- Creating a Dockerfile with best practices
- Building and running Docker images/containers
- Managing dependencies with requirements.txt
- Pushing to Docker Hub
- Proper project structure

---

## 📁 File Structure & Purpose

```
Docker project/
├── app.py                    # Main Python application script (uses numpy)
├── Dockerfile               # Instructions to build Docker image
├── requirements.txt         # Python dependencies list (numpy)
├── .gitignore              # Git files to ignore (for GitHub)
├── .dockerignore           # Docker files to ignore (for image build)
└── README.md               # This file - project documentation
```

### File Details:

| File | Purpose |
|------|---------|
| **app.py** | Main application - generates random numbers every 5 seconds using numpy |
| **Dockerfile** | Blueprint for building Docker image with all commands explained |
| **requirements.txt** | Lists Python packages (numpy==1.24.0) |
| **.gitignore** | Tells Git which files NOT to track (cache, venv, etc.) |
| **.dockerignore** | Tells Docker which files NOT to copy into image (keeps image smaller) |
| **README.md** | Documentation (this file) |

---

## 🚀 Quick Start Commands

### 1. Build the Docker Image
```bash
docker build -t python-docker-app .
```
**What it does:** Creates a Docker image named `python-docker-app` from the Dockerfile
- `-t` flag: tags/names the image
- `.` : uses Dockerfile in current directory

### 2. Run the Container (Interactive)
```bash
docker run -it python-docker-app
```
**What it does:** Runs container in interactive mode (see output in real-time)
- `-i` : keep stdin open even if not attached
- `-t` : allocate a pseudo-terminal
- Press `Ctrl+C` to stop

### 3. Run the Container (Background)
```bash
docker run -d --name my-app python-docker-app
```
**What it does:** Runs container in background
- `-d` : detach (run in background)
- `--name my-app` : gives container a readable name

### 4. View Running Containers
```bash
docker ps
```
**What it does:** Lists all running containers

### 5. View Container Logs
```bash
docker logs my-app
```
**What it does:** Shows output from the running container
- Use `--follow` to stream logs: `docker logs --follow my-app`

### 6. Stop the Container
```bash
docker stop my-app
```
**What it does:** Gracefully stops the running container

### 7. Remove Container
```bash
docker rm my-app
```
**What it does:** Deletes the stopped container

### 8. Remove Image
```bash
docker rmi python-docker-app
```
**What it does:** Deletes the Docker image (frees up space)

---

## 🐳 Docker Hub Commands (Push & Share)

### 1. Login to Docker Hub
```bash
docker login
```
**What it does:** Authenticates you with Docker Hub
- Enter your Docker Hub username
- Enter your Docker Hub password/token

### 2. Tag Image for Docker Hub
```bash
docker tag python-docker-app YOUR_USERNAME/python-docker-app:latest
```
**What it does:** Creates a new tag pointing to your image
- Replace `YOUR_USERNAME` with your actual Docker Hub username
- `:latest` is the version tag (default is "latest")

### 3. Push to Docker Hub
```bash
docker push YOUR_USERNAME/python-docker-app:latest
```
**What it does:** Uploads image to Docker Hub (public repository)
- Now anyone can pull and run it: `docker run YOUR_USERNAME/python-docker-app`

### 4. Pull from Docker Hub (Later)
```bash
docker pull YOUR_USERNAME/python-docker-app
```
**What it does:** Downloads the image from Docker Hub

### 5. Run Directly from Docker Hub
```bash
docker run -it YOUR_USERNAME/python-docker-app:latest
```
**What it does:** Pulls and runs the image in one command

---

## � Docker Hub - Share Your Image

### 1. Create Docker Hub Account
- Go to https://hub.docker.com
- Sign up for a free account
- Confirm your email

### 2. Login to Docker Hub from Terminal
```bash
docker login
```
**Enter:**
- Your Docker Hub username
- Your Docker Hub password or access token

### 3. Tag Your Image for Docker Hub
```bash
docker tag python-docker-app YOUR_USERNAME/python-docker-app:latest
```
**Replace `YOUR_USERNAME` with your Docker Hub username**

Examples:
```bash
docker tag python-docker-app shariq123/python-docker-app:latest
docker tag python-docker-app johndoe/python-docker-app:v1.0
docker tag python-docker-app myname/python-docker-app:2025
```

### 4. Push Image to Docker Hub
```bash
docker push YOUR_USERNAME/python-docker-app:latest
```
**What it does:** Uploads your image to Docker Hub (public repository)

### 5. Now Others Can Use It!
Anyone can run your image directly from Docker Hub:
```bash
docker run -it YOUR_USERNAME/python-docker-app:latest
```

### 6. View Your Image on Docker Hub
Visit: `https://hub.docker.com/r/YOUR_USERNAME/python-docker-app`

### Complete Docker Hub Workflow
```bash
# 1. Build locally
docker build -t python-docker-app .

# 2. Test it works
docker run -it python-docker-app

# 3. Login to Docker Hub
docker login

# 4. Tag it
docker tag python-docker-app shariq123/python-docker-app:latest

# 5. Push it
docker push shariq123/python-docker-app:latest

# 6. Test pulling from Docker Hub (from another computer)
docker pull shariq123/python-docker-app:latest
docker run -it shariq123/python-docker-app:latest
```

---

```bash
# 1. Build image locally
docker build -t python-docker-app .

# 2. Test it locally
docker run -it python-docker-app

# 3. Login to Docker Hub
docker login

# 4. Tag your image
docker tag python-docker-app shariq123/python-docker-app:v1.0

# 5. Push to Docker Hub
docker push shariq123/python-docker-app:v1.0

# 6. Push latest version too
docker tag python-docker-app shariq123/python-docker-app:latest
docker push shariq123/python-docker-app:latest
```

---

## 🔧 Advanced Commands

### View Image Details
```bash
docker inspect python-docker-app
```

### Prune Unused Images & Containers
```bash
docker system prune
```
**Warning:** Deletes all unused containers, images, and networks

### Run with Resource Limits
```bash
docker run -it --cpus="1" --memory="256m" python-docker-app
```
**What it does:** Limits container to 1 CPU and 256MB RAM

### Run with Port Mapping (if app had web server)
```bash
docker run -p 8080:5000 python-docker-app
```
**What it does:** Maps host port 8080 to container port 5000

### Execute Command in Running Container
```bash
docker exec -it my-app bash
```
**What it does:** Opens a bash shell inside the running container

---

## 🛠️ Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "docker: command not found" | Install Docker Desktop from docker.com |
| "permission denied" | Add user to docker group: `sudo usermod -aG docker $USER` |
| "image not found" | Rebuild with `docker build -t python-docker-app .` |
| "port already in use" | Change port: `docker run -p 9000:5000 image-name` |

---

## 📚 Docker Best Practices Used in This Project

✅ **Slim Base Image** - Uses `python:3.11-slim` instead of full image (smaller = faster)
✅ **Layer Caching** - Copies requirements.txt before app.py for better caching
✅ **Comments** - Dockerfile has detailed comments explaining each command
✅ **.dockerignore** - Excludes unnecessary files from build (smaller images)
✅ **PYTHONUNBUFFERED** - Environment variable ensures instant log output
✅ **Working Directory** - Uses WORKDIR for cleaner file management

---

## 📤 Complete Deployment Guide

### Step 1: Build Docker Image Locally

**Navigate to project:**
```bash
cd "c:/Users/SHARIQ/OneDrive/Desktop/Docker project"
```

**Build image:**
```bash
docker build -t python-docker-app .
```

**Verify image created:**
```bash
docker images
```

### Step 2: Test Image Locally

```bash
docker run -it python-docker-app
```

**Expected output:**
```
[2026-01-13 10:30:45] Hello from Docker! Random numbers: [42 87 15 63 29]
[2026-01-13 10:30:50] Hello from Docker! Random numbers: [71 33 88 19 54]
```

Press `Ctrl+C` to stop.

### Step 3: Upload to Docker Hub

#### 3.1 Create Docker Hub Account
1. Go to https://hub.docker.com
2. Sign up with username, email, password
3. Verify your email

#### 3.2 Login to Docker
```bash
docker login
```
Enter your Docker Hub credentials.

#### 3.3 Tag Image for Docker Hub
```bash
docker tag python-docker-app YOUR_USERNAME/python-docker-app:latest
```

**Replace `YOUR_USERNAME` with your Docker Hub username**

Examples:
```bash
docker tag python-docker-app shariq/python-docker-app:latest
docker tag python-docker-app johndoe/python-docker-app:v1.0
```

#### 3.4 Push to Docker Hub
```bash
docker push YOUR_USERNAME/python-docker-app:latest
```

#### 3.5 Verify Online
Visit: `https://hub.docker.com/r/YOUR_USERNAME/python-docker-app`

#### 3.6 Anyone Can Now Use It
```bash
docker run -it YOUR_USERNAME/python-docker-app:latest
```

### Step 4: Upload Project to GitHub

#### 4.1 Create GitHub Repository

1. Go to https://github.com
2. Click "+" → "New repository"
3. Choose repository name (see suggestions below)
4. Add description: "Python application containerized with Docker. Demonstrates Docker fundamentals with NumPy integration."
5. Select **Public**
6. Click "Create repository"

#### 4.2 Repository Name Ideas for Portfolio

| Name | Why It's Good |
|------|---------------|
| **`python-docker-numpy`** ⭐ | Shows Python, Docker, NumPy skills |
| `docker-python-app` | Simple and clear |
| `numpy-docker-demo` | Demonstrates integration |
| `containerized-python-app` | Shows DevOps knowledge |

**Recommended: `python-docker-numpy`** - Impresses employers!

#### 4.3 Initialize Git Locally

```bash
cd "c:/Users/SHARIQ/OneDrive/Desktop/Docker project"
git init
```

#### 4.4 Configure Git (First Time Only)
```bash
git config user.name "Your Name"
git config user.email "your@email.com"
```

#### 4.5 Add Remote Repository
```bash
git remote add origin https://github.com/YOUR_USERNAME/python-docker-numpy.git
```

**Replace:**
- `YOUR_USERNAME` = Your GitHub username
- `python-docker-numpy` = Your chosen repo name

#### 4.6 Add Files and Commit
```bash
git add .
git commit -m "Initial commit: Python Docker app with NumPy"
```

#### 4.7 Push to GitHub
```bash
git branch -M main
git push -u origin main
```

#### 4.8 Verify on GitHub
Visit: `https://github.com/YOUR_USERNAME/python-docker-numpy`

### Step 5: Portfolio Optimization

**Add to your portfolio:**
- GitHub repo link: `https://github.com/YOUR_USERNAME/python-docker-numpy`
- Docker Hub link: `https://hub.docker.com/r/YOUR_USERNAME/python-docker-app`

**What this demonstrates:**
- ✅ Docker skills (containerization, image building)
- ✅ Python skills (NumPy integration)
- ✅ DevOps knowledge (Docker Hub deployment)
- ✅ Git/GitHub proficiency (version control)
- ✅ Modern development practices

---

---

## 📝 Notes

- This project uses only Python built-in libraries (no external dependencies)
- The app runs indefinitely - use `Ctrl+C` to stop in interactive mode
- Images are immutable - rebuild to make changes
- Containers are ephemeral - data is lost when stopped (unless using volumes)

---

**Happy Dockering! 🚀**

## 🙏 Thanks & Resources

- **Docker Official Docs:** https://docs.docker.com
- **NumPy Docs:** https://numpy.org/doc
- **Docker Hub:** https://hub.docker.com
- **GitHub:** For storing your code and version control

---

**Project created to learn Docker basics with Python!**
