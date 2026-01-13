# Python Docker Application - Project Guide

This is a **multi-container Python application** using Docker and Docker Compose that:
- **Container 1**: Generates random numbers using **NumPy** every 5 seconds
- **Container 2**: Processes data using **Pandas**
- Both containers communicate on a shared network
- It demonstrates Docker Compose for orchestrating multiple containers

---

## 📁 File Structure & Purpose

```
Docker project/
├── app.py                        # Container 1: Data generator (uses numpy)
├── processor.py                  # Container 2: Data processor
├── Dockerfile                    # Single Dockerfile for both containers
├── requirements.txt              # Dependencies (used by both containers)
├── docker-compose.yml            # Orchestrates both containers
├── .gitignore                    # Git files to ignore (for GitHub)
├── .dockerignore                 # Docker files to ignore (for image build)
└── README.md                     # This file - project documentation
```

### File Details:

| File | Purpose |
|------|---------|
| **app.py** | Container 1 - generates random numbers every 5 seconds using numpy |
| **processor.py** | Container 2 - processes data using pandas |
| **Dockerfile** | Single blueprint used to build the image `python-data-pipeline` for both containers |
| **requirements.txt** | Lists Python packages (numpy==1.24.0, pandas==2.0.0) - shared by both containers |
| **docker-compose.yml** | Orchestrates both containers with one command - specifies which .py file each runs |
| **.gitignore** | Tells Git which files NOT to track (cache, venv, etc.) |
| **.dockerignore** | Tells Docker which files NOT to copy into image (keeps image smaller) |
| **README.md** | Documentation (this file) |

---

## 🚀 Quick Start Commands (With Docker Compose - TWO Containers)

### Option 1: Run Both Containers Together with Docker Compose 🎯 RECOMMENDED

```bash
docker-compose up
```

**What it does:** 
- Builds the Docker image `python-data-pipeline` (if not already built)
- Starts both containers simultaneously
- Container 1 (app_generator): Generates random numbers every 5 seconds
- Container 2 (app_processor): Processes data every 7 seconds
- Both containers run on the same internal network (`python-network`)

**To run in background:**
```bash
docker-compose up -d
```

**To view logs:**
```bash
docker-compose logs -f
```

**To stop all containers:**
```bash
docker-compose down
```

---

## 🏗️ Architecture: ONE IMAGE → MULTIPLE CONTAINERS

### How It Works

When you build the Docker image:
```bash
docker build -t python-data-pipeline .
```

You create **ONE Docker image** that contains:
- Both `app.py` and `processor.py`
- All dependencies (numpy, pandas)
- Python 3.11 runtime

When docker-compose runs:
```bash
docker-compose up
```

It creates **TWO containers** from that **SAME image**:

```
IMAGE: python-data-pipeline (ONE - shared by both)
│
├── Container 1: python-generator (runs: python app.py)
│
└── Container 2: python-processor (runs: python processor.py)
```

### Book Analogy 📚

Think of it like reading a book:
- **Image** = One physical book (ONE)
- **Containers** = Multiple people reading from it (MULTIPLE)
- Each person can read a different page simultaneously

**Benefits:**
- 🔹 Saves disk space (one image, not two)
- 🔹 Faster to build (build once, run many times)
- 🔹 Consistent environment for all containers
- 🔹 Easy to scale (create more containers from same image)

---

#### Without Docker Compose (Manual - Multiple Commands):
```bash
# Step 1: BUILD the image (manually)
docker build -t python-data-pipeline .

# Step 2: RUN Container 1 (manually)
docker run -d --name python-generator python-data-pipeline python app.py

# Step 2: RUN Container 2 (manually)
docker run -d --name python-processor python-data-pipeline python processor.py
```

**3 commands needed** - you handle building and running separately

---

#### With Docker Compose (Automated - One Command):
```bash
# Does EVERYTHING: BUILD (if needed) + RUN both containers
docker-compose up
```

**1 command does it all** - docker-compose automatically:
1. Builds the image (if not already built)
2. Creates and starts both containers
3. Sets up networking between them

**Key Point:** Docker Compose is an **all-in-one orchestration tool** - it handles both image building AND running multiple containers!

**Benefits:**
- 🔹 One command instead of 3
- 🔹 Automatic networking between containers
- 🔹 Easy to manage (logs, restart, stop all at once)
- 🔹 Reproducible setup (everyone runs the same config)
- 🔹 Layer caching speeds up rebuilds

---

### Option 2: Manual Docker Commands (OLD METHOD - For Reference Only)

#### 1. Build the Docker Image
```bash
docker build -t python-data-pipeline .
```

**What it does:** Creates a Docker image named `python-data-pipeline` from the Dockerfile

**Breaking down the command:**
- `docker` = Docker command
- `build` = Build an image
- `-t python-data-pipeline` = Tag/name the image as "python-data-pipeline"
  - `-t` flag = Tag (name) for the image
  - `python-data-pipeline` = The name you're giving it (represents both .py files)
- `.` = Use Dockerfile from current directory (the dot means "here")

**Example output:**
```
Sending build context to Docker daemon
Step 1/6 : FROM python:3.11-slim
Step 2/6 : WORKDIR /app
...
Successfully built abc123def456
Successfully tagged python-data-pipeline:latest
```

---

### 2. Run Container 1 (Generator) in Background
```bash
docker run -d --name python-generator python-data-pipeline python app.py
```

**What it does:** Runs the generator container in background

**Breaking down the command:**
- `docker run` = Run a new container
- `-d` flag = Detach (run in background)
- `--name python-generator` = Give the container a name
- `python-data-pipeline` = Image name to run
- `python app.py` = Command to run inside the container

---

### 3. Run Container 2 (Processor) in Background
```bash
docker run -d --name python-processor python-data-pipeline python processor.py
```

**What it does:** Runs the processor container in background

**Breaking down the command:**
- `docker run` = Run a new container
- `-d` flag = Detach (run in background)
- `--name python-processor` = Give the container a name
- `python-data-pipeline` = Image name to run
- `python processor.py` = Command to run inside the container

---

### 4. View Logs
```bash
docker logs -f python-generator
docker logs -f python-processor
```

**What it does:** Shows real-time output from each container

---

### 5. Stop Containers
```bash
docker stop python-generator python-processor
```

**What it does:** Stops both containers

**Now you can use the container name `my-app` in other commands**

---

### 4. View Running Containers
```bash
docker ps
```

**What it does:** Lists all currently running containers

**What you'll see:**
```
CONTAINER ID   IMAGE                 COMMAND            STATUS
abc123def456   python-docker-app     "python app.py"    Up 2 minutes  my-app
```

**To see stopped containers too:**
```bash
docker ps -a
```
- `-a` flag = All containers (including stopped ones)

---

### 5. View Container Logs
```bash
docker logs my-app
```

**What it does:** Shows output from the running container

**Breaking down the command:**
- `docker` = Docker command
- `logs` = Show logs/output
- `my-app` = Container name (from `--name my-app`)

**What you'll see:**
```
[2026-01-13 10:30:45] Hello from Docker! Random numbers: [42 87 15 63 29]
[2026-01-13 10:30:50] Hello from Docker! Random numbers: [71 33 88 19 54]
[2026-01-13 10:30:55] Hello from Docker! Random numbers: [45 62 91 28 76]
```

**To see logs in real-time (keep watching):**
```bash
docker logs --follow my-app
```
- `--follow` flag = Stream logs continuously (like `tail -f`)

**To stop streaming:** Press `Ctrl+C`

---

### 6. Stop the Container
```bash
docker stop my-app
```

**What it does:** Gracefully stops the running container

**Breaking down the command:**
- `docker` = Docker command
- `stop` = Stop a container
- `my-app` = Container name to stop

**Note:** Container still exists, just not running (can restart with `docker start my-app`)

---

### 7. Remove Container
```bash
docker rm my-app
```

**What it does:** Deletes the stopped container completely

**Breaking down the command:**
- `docker` = Docker command
- `rm` = Remove
- `my-app` = Container name to delete

**Warning:** This deletes the container. You can't recover it!

**To remove running container forcefully:**
```bash
docker rm -f my-app
```
- `-f` flag = Force remove (even if running)

---

### 8. Remove Image
```bash
docker rmi python-docker-app
```

**What it does:** Deletes the Docker image (frees up disk space)

**Breaking down the command:**
- `docker` = Docker command
- `rmi` = Remove image
- `python-docker-app` = Image name to delete

**Note:** Must delete all containers using this image first!

---

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

🔹 **Slim Base Image** - Uses `python:3.11-slim` instead of full image (smaller = faster)
🔹 **Layer Caching** - Copies requirements.txt before app.py for better caching
🔹 **Comments** - Dockerfile has detailed comments explaining each command
🔹 **.dockerignore** - Excludes unnecessary files from build (smaller images)
🔹 **PYTHONUNBUFFERED** - Environment variable ensures instant log output
🔹 **Working Directory** - Uses WORKDIR for cleaner file management

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
- GitHub repo link: `https://github.com/muk0644/docker-containerized-python-app`
- Docker Hub link: `https://hub.docker.com/r/muk0644/python-docker-app`

**What this demonstrates:**

#### 🐳 Docker Skills
- **Container Knowledge** - Understand how to containerize applications
- **Image Building** - Create optimized Docker images from Dockerfile
- **Layering & Caching** - Use best practices (COPY requirements first)
- **Image Optimization** - Use slim base images to reduce size
- **Docker Hub Deployment** - Push images to public registries

**Show employers:** You can package any application for deployment!

#### 🐍 Python Skills
- **NumPy Integration** - Use scientific computing libraries
- **Dependency Management** - Manage requirements.txt properly
- **Environment Variables** - Handle configuration via .env
- **Clean Code** - Well-structured, readable Python scripts
- **Library Usage** - Demonstrate proficiency with external packages

**Show employers:** You write production-ready Python code!

#### ⚙️ DevOps Knowledge
- **Infrastructure Concepts** - Understand containerization principles
- **Deployment Process** - Know how to deploy applications
- **Cloud-Ready** - Your app can run anywhere (local, cloud, servers)
- **Scalability** - Docker apps are easily scalable
- **Best Practices** - Follow industry standards

**Show employers:** You understand modern DevOps practices!

#### 🔗 Git/GitHub Proficiency
- **Version Control** - Track code changes with meaningful commits
- **Repository Management** - Organize projects professionally
- **Collaboration Skills** - Know how to work in teams
- **Documentation** - Write clear READMEs
- **Public Portfolio** - Share your work publicly

**Show employers:** You use professional development workflows!

#### 🚀 Modern Development Practices
- **Containerization** - Industry-standard deployment method
- **Documentation** - Comprehensive README with examples
- **Multiple Environments** - Work locally and on cloud
- **Automation** - Automated builds and deployments
- **Best Practices** - Follow Docker/Python/Git conventions

**Show employers:** You're up-to-date with current tech trends!

---

## 💼 How to Add to Your Portfolio Website

### Option 1: Add to Your Resume
```
Docker & Python Project - docker-containerized-python-app
• Built containerized Python application using Docker with NumPy
• Created Dockerfile with best practices for image optimization
• Deployed to Docker Hub for public sharing and accessibility
• Managed project with Git/GitHub for version control
Technologies: Python, Docker, NumPy, Git, GitHub, DevOps
GitHub: github.com/muk0644/docker-containerized-python-app
Docker Hub: hub.docker.com/r/muk0644/python-docker-app
```

### Option 2: Add to Portfolio Website
Include these links:
- 🔗 **GitHub Repository:** https://github.com/muk0644/docker-containerized-python-app
- 🐳 **Docker Hub Image:** https://hub.docker.com/r/muk0644/python-docker-app
- 📚 **Full Documentation:** See README.md in repository

### Option 3: Highlight in LinkedIn/Profile
```
"Developed and containerized a Python application using Docker, 
demonstrating proficiency in modern DevOps practices and cloud deployment. 
Image available on Docker Hub for production use."
```

---

## 🎯 Why Employers Love This Project

1. **Shows Real Skills** - Not just tutorials, actual implementation
2. **DevOps Knowledge** - Understanding of containerization (hot skill!)
3. **Complete Workflow** - GitHub + Docker Hub shows full deployment pipeline
4. **Scalable Thinking** - Demonstrates cloud-native development
5. **Professional** - Well-documented, organized, production-ready

---

## 📊 Project Statistics to Share

- **Languages:** Python
- **Technologies:** Docker, NumPy, Git
- **Files:** 6 (app.py, Dockerfile, requirements.txt, README.md, .gitignore, .dockerignore)
- **Documentation:** Comprehensive with examples
- **Deployment:** Both GitHub and Docker Hub

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
