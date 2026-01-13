# Python Kubernetes Application - Project Guide

This is a **multi-pod Python application** using Kubernetes that:
- **Pod 1 (Generator)**: Generates random numbers using **NumPy** every 5 seconds
- **Pod 2 (Processor)**: Processes data using **Pandas** every 7 seconds  
- Both pods run in the same `python-app` namespace
- It demonstrates Kubernetes Deployments for orchestrating multiple workloads

---

## Understanding: Docker Compose vs Kubernetes

### Why Do We Still Need Dockerfile?

**Short Answer:** The Dockerfile is the **blueprint** for creating the application image. Whether you use Docker Compose or Kubernetes, you need it to build the image first.

Think of it like a recipe:
- **Dockerfile** = Recipe (instructions to make a cake)
- **Docker Image** = The actual cake you baked
- **Docker Compose** = Running 2 plates of that cake side-by-side (locally)
- **Kubernetes** = Running thousands of plates of that cake on a huge restaurant chain (in clusters)

**The Workflow:**
```
Step 1: Write app.py + processor.py + requirements.txt
        ↓
Step 2: Write Dockerfile (the recipe)
        ↓
Step 3: docker build → Creates IMAGE (the actual cake)
        ↓
Step 4a (Docker Compose):
  docker-compose up → Runs 2 containers from that image locally
        ↓
Step 4b (Kubernetes):
  kubectl apply → Runs 2 pods from that image in a cluster
```

Both Docker Compose and Kubernetes **use the same Dockerfile** and the same image. The difference is **where and how** you run it.

---

### Docker Compose vs Kubernetes: Simple Comparison

**DOCKER COMPOSE (Simple, Local Development):**
```
Your Computer:
┌────────────────────────────────────┐
│ docker-compose.yml tells Docker:   │
├────────────────────────────────────┤
│ • Build image (from Dockerfile)    │
│ • Create Container 1 (runs app.py) │
│ • Create Container 2 (runs processor.py) │
│ • Connect them on a network        │
└────────────────────────────────────┘
Commands:
docker-compose up    (start everything)
docker-compose down  (stop everything)
docker-compose logs  (see output)
```

**KUBERNETES (Professional, Scalable, Multi-Machine):**
```
Kubernetes Cluster (could be 100s of machines):
┌────────────────────────────────────┐
│ kubernetes.yaml tells Kubernetes:  │
├────────────────────────────────────┤
│ • Create namespace python-app      │
│ • Deploy Pod 1 (runs app.py)       │
│ • Deploy Pod 2 (runs processor.py) │
│ • Manage them, restart if crash    │
│ • Handle networking automatically  │
└────────────────────────────────────┘
Commands:
kubectl apply       (start everything)
kubectl delete      (stop everything)
kubectl logs        (see output)
```

---

### Terminology Comparison: Docker vs Kubernetes (Analogies)

Think of Docker and Kubernetes like a **restaurant business:**

| Docker Concept | Real Life | Kubernetes Concept | Real Life |
|---|---|---|---|
| **Container** | Individual box of food | **Pod** | Individual box of food (can hold multiple containers, usually 1) |
| **Image** | Recipe + ingredients (ready to cook) | **Image** | Same recipe + ingredients |
| **Docker Daemon** | Chef cooking in your kitchen | **Cluster** | Huge restaurant chain with many kitchens |
| **Container Registry** | Recipe book store | **Container Registry** | Same recipe book store (Docker Hub) |
| **docker-compose.yml** | Instruction sheet for 1 kitchen | **kubernetes.yaml** | Instruction sheet for entire restaurant chain |
| **Network (Docker)** | Waiter passing food between kitchens | **Service (K8s)** | Waiter passing food between kitchens |
| **Volume (Docker)** | Storage room | **PersistentVolume (K8s)** | Storage room (but works across multiple kitchens) |
| **Port Mapping** | Which window to serve food from | **Ingress** | Which doors customers enter the restaurant |

---

### The Real Difference Explained Simply

**Docker Compose:** "I want to run this app locally on my laptop using 2 containers"
- All containers run on 1 machine (your computer)
- Good for development and testing
- Uses `docker-compose.yml` to define setup

**Kubernetes:** "I want to run this app on 100 servers, and automatically restart it if something breaks"
- Containers (pods) spread across many machines (cluster)
- Good for production and scaling
- Uses `kubernetes.yaml` to define setup
- Kubernetes manages everything for you

---

### How Files Flow Through the System

**DOCKER COMPOSE WORKFLOW:**
```
1. Your code (app.py, processor.py, requirements.txt)
   ↓ (read by)
2. Dockerfile
   ↓ (creates)
3. Docker Image
   ↓ (used by)
4. docker-compose.yml
   ↓ (runs)
5. Container 1 + Container 2 on YOUR COMPUTER
```

**KUBERNETES WORKFLOW:**
```
1. Your code (app.py, processor.py, requirements.txt)
   ↓ (read by)
2. Dockerfile
   ↓ (creates)
3. Docker Image (stored in Docker Hub or local registry)
   ↓ (used by)
4. kubernetes.yaml
   ↓ (tells Kubernetes to)
5. Pod 1 + Pod 2 on KUBERNETES CLUSTER (could be 1000+ machines)
```

Both start with the same Dockerfile, but end at different places.

---

### Key Kubernetes Concepts Explained

**NAMESPACE:**
- Like a folder or department in a company
- Isolates resources from each other
- In this project: `python-app` namespace keeps our pods separate

**DEPLOYMENT:**
- A manager that says "I want this pod running 24/7"
- If pod crashes, it automatically restarts it
- Can scale up/down: "Run 1 copy" or "Run 10 copies"
- In this project: 2 deployments (generator + processor)

**POD:**
- Smallest unit in Kubernetes (like a container, but more flexible)
- Usually runs 1 container, but can run multiple
- Gets its own IP address
- In this project: 1 pod per deployment

**CLUSTER:**
- Group of machines (nodes) working together
- Kubernetes spreads your pods across these machines
- If 1 machine dies, Kubernetes moves your pods to another machine
- In this project: Even on Minikube (1 machine), it's still a "cluster"

**NODE:**
- An actual machine (physical or virtual) in the cluster
- Runs multiple pods
- Has Docker installed to run containers

**CONTAINER REGISTRY:**
- Where Docker images are stored (like Docker Hub)
- Kubernetes pulls images from here
- In this project: We use local images (no upload needed for local testing)

---

### Docker Compose vs Kubernetes: Same Job, Different Scale

**Docker Compose Analogy:**
Think of it like making coffee at home:
- You buy ingredients (Dockerfile)
- Make coffee (docker build)
- Pour in 2 cups (2 containers)
- Done! Just for you.

**Kubernetes Analogy:**
Think of it like running a coffee chain:
- You have the recipe (Dockerfile)
- Make coffee (docker build, image in registry)
- Have 2 baristas always making coffee (2 pods)
- 100 coffee shops across the country (nodes in cluster)
- Customers everywhere (users)
- If 1 shop closes, others still serve (fault tolerance)
- Can open new shops quickly (scaling)

---

## What Are Ports and Hosts?

### Understanding Ports and Hosts (Simple Explanation)

Imagine your computer is a **building** with many **rooms**.

- **Host/IP Address** = The address of the building (like "123 Main Street")
- **Port** = A room number in that building (like "Room 5000")
- **Application** = A person inside the room who receives messages

When someone wants to talk to your application:
- They go to the **building address** (host/IP)
- They knock on **room number** (port)
- The **person inside** (your app) answers

---

### When Do You Need Ports? (Decision Guide)

**YOU NEED PORTS IF:**
- Your application has a **web server** (like Flask, Express, Django running on port 8080)
- Your app needs **internet communication** (API server, database, etc.)
- You want **people outside** to access your app

**YOU DON'T NEED PORTS IF:**
- Your app just **prints output** to logs (like this project!)
- Your app doesn't **receive any input** from outside
- Your pods communicate **internally** within Kubernetes

**OUR PROJECT:** We DON'T need ports!
- `app.py` just generates random numbers and prints them
- `processor.py` just processes data and prints results
- No one from outside needs to access these pods
- They don't need to receive internet traffic

---

### In Our Project: Why We Don't Need Ports

**What our app does:**
```
app.py:
  ↓ (generates numbers)
  ↓ (prints to console)
  ↓ (pods logs show output)
  
processor.py:
  ↓ (processes data)
  ↓ (prints to console)
  ↓ (pods logs show output)
```

No internet traffic needed. No external requests. Just output.

**If we added ports anyway:**
- It would be **useless** (nothing to listen to)
- The ports would **stay open but unused** (like a phone that never rings)
- It would waste **memory and resources**

---

### Port and Host Explained with Real Examples

**Example 1: Web Server (NEEDS PORT)**
```
Application: Flask web server
Host: 192.168.1.10 (your computer)
Port: 5000 (Flask runs here by default)

What happens:
1. You type in browser: http://192.168.1.10:5000
2. Browser goes to Host 192.168.1.10
3. Knocks on Port 5000
4. Flask responds with web page
```

**Example 2: Database Server (NEEDS PORT)**
```
Application: PostgreSQL database
Host: 192.168.1.20 (server)
Port: 5432 (database listens here)

What happens:
1. Python code connects to: 192.168.1.20:5432
2. Sends query: "SELECT * FROM users"
3. Database processes at Port 5432
4. Sends results back
```

**Example 3: Our Project (DOESN'T NEED PORT)**
```
Application: app.py generator
Host: doesn't matter (no one connects to it)
Port: doesn't matter (no one connects to it)

What happens:
1. Pod starts running app.py
2. Generates numbers
3. Prints to logs
4. You read logs with: kubectl logs
5. Done! No port needed.
```

---

### Docker vs Kubernetes: Port Handling

**DOCKER (with docker-compose.yml):**
```yaml
services:
  web:
    image: my-app
    ports:
      - "8080:5000"  # Host port 8080 → Container port 5000
```
Meaning: If someone visits `localhost:8080`, Docker forwards to container port 5000

**KUBERNETES (with kubernetes.yaml):**
```yaml
containers:
- name: app
  image: my-app
  ports:
  - containerPort: 5000  # Container listens on port 5000
```
Meaning: Container port 5000 is open, but only other pods can reach it (not the internet)

**Important:** Kubernetes ports are **internal only** by default!
- To expose to internet, you need **Service** or **Ingress** (advanced topics)

---

### What If We Added Ports to Our Project?

**Current Setup (No Ports):**
```yaml
containers:
- name: generator
  image: python-data-pipeline
  command: ["python", "app.py"]
  # NO PORTS DEFINED
```

**If we added ports (Wrong for this project):**
```yaml
containers:
- name: generator
  image: python-data-pipeline
  command: ["python", "app.py"]
  ports:
  - containerPort: 5000  # Wasted! Nothing listens here
```

**What would happen:**
- Port 5000 would be **open but unused**
- No application listening on port 5000
- Would waste **memory and resources**
- Doesn't break anything, just unnecessary

---

### Do We Need to Change Dockerfile for Ports?

**Short Answer: NO!**

Dockerfile doesn't define ports. Here's why:

**What Dockerfile DOES:**
- Defines base image (Python 3.11)
- Installs dependencies (numpy, pandas)
- Copies files
- Sets the command to run

**What Dockerfile DOESN'T define:**
- Ports (that's a runtime decision)
- Host configuration (that's deployment decision)
- Whether it's Docker or Kubernetes (image is generic)

**Real Example:**
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .
EXPOSE 5000  # This is optional! Just documentation!
CMD ["python", "app.py"]
```

The `EXPOSE 5000` line is **just documentation**. It does nothing.
- Docker Compose uses `ports:` section in yaml (not Dockerfile)
- Kubernetes uses `ports:` section in yaml (not Dockerfile)
- The Dockerfile is generic for both

**Our Dockerfile (No EXPOSE needed):**
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .
COPY processor.py .
CMD ["python", "app.py"]
# No EXPOSE needed because our app doesn't listen to ports
```

---

### EXPOSE vs ports: What's the Difference?

**EXPOSE in Dockerfile:**
- Optional line just for documentation
- Says "this app MIGHT listen on port 5000" (but doesn't force it)
- Doesn't actually open anything
- Ignored by both Docker Compose and Kubernetes

**ports: in docker-compose.yml:**
- ACTUALLY maps ports
- Tells Docker: "Listen on host port 8080, send to container port 5000"
- Creates the actual connection

**ports: in kubernetes.yaml:**
- ACTUALLY opens port inside pod
- But external world still can't reach it (need Service/Ingress)
- Other pods in cluster CAN reach it

**Our Project:** We don't need any of this!

---

### Quick Decision Tree: Do I Need Ports?

```
Does your application receive internet traffic?
    ↓
    YES → Need ports (web server, API, database, etc.)
    NO  → Don't need ports (data processing, logging, etc.)
    
Our app: Generates and processes numbers, prints logs
    ↓
    NO external traffic needed
    ↓
    DON'T NEED PORTS
```

---

### If You Ever Need to Add Ports (Future Reference)

**In Docker Compose:**
```yaml
services:
  web:
    image: python-data-pipeline
    ports:
      - "8080:5000"  # Host:Container
```
This means: External requests to host port 8080 go to container port 5000

**In Kubernetes:**
```yaml
containers:
- name: app
  image: python-data-pipeline
  ports:
  - containerPort: 5000
    
# To expose to internet, also add Service:
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 5000
```

**In Dockerfile (optional documentation only):**
```dockerfile
EXPOSE 5000
```
This just tells readers "this image probably listens on port 5000" (doesn't do anything)

---

### Summary: Ports & Hosts for Our Project

| Question | Answer |
|----------|--------|
| Do we need ports? | NO - our app just prints logs |
| Do we need to configure host? | NO - pods communicate internally |
| Do we need EXPOSE in Dockerfile? | NO - not needed for this project |
| Do we need ports: in kubernetes.yaml? | NO - no external traffic |
| Will adding them hurt? | NO - but wastes resources (not worth it) |
| When would we need them? | If we add a web server (Flask) or API endpoint |

**Bottom Line:** Our current setup is perfect as-is. No ports, no hosts, no special configuration needed!

---

## 📁 File Structure & Purpose

```
Kubernetes project/
├── app.py                    # Pod 1: Data generator (uses numpy)
├── processor.py              # Pod 2: Data processor (uses pandas)
├── requirements.txt          # Dependencies (numpy==1.24.0, pandas==2.0.0)
├── Dockerfile                # Single image used for both pods
├── kubernetes.yaml           # Kubernetes deployment manifest
├── .gitignore                # Git files to ignore
├── .dockerignore             # Docker files to ignore
└── README.md                 # This file - project documentation
```

### File Details:

| File | Purpose |
|------|---------|
| **app.py** | Pod 1 - generates random numbers every 5 seconds using numpy |
| **processor.py** | Pod 2 - processes data using pandas |
| **requirements.txt** | Python packages (numpy==1.24.0, pandas==2.0.0) |
| **Dockerfile** | Builds single image `python-data-pipeline` for both pods |
| **kubernetes.yaml** | K8s manifest with namespace, and 2 deployments |
| **.gitignore** | Git ignore file |
| **.dockerignore** | Docker ignore file |
| **README.md** | Documentation (this file) |

---

## � Prerequisites

Before deploying to Kubernetes, ensure you have:

1. **Kubernetes Cluster**: Minikube, Docker Desktop, or cloud provider (AWS EKS, Google GKE, Azure AKS)
   - Verify: `kubectl cluster-info`

2. **kubectl installed**: Command-line tool for Kubernetes
   - Verify: `kubectl version --client`

3. **Docker installed**: To build the image
   - Verify: `docker --version`

---

## 🚀 Complete Deployment Process (Step-by-Step)

### Step 1: Verify Prerequisites
```bash
# Check Docker
docker --version

# Check kubectl
kubectl version --client

# Check Kubernetes cluster
kubectl cluster-info

# Check current context
kubectl config current-context
```

### Step 2: Build Docker Image
```bash
# Navigate to project directory
cd "c:/Users/SHARIQ/OneDrive/Desktop/Kubernetes project"

# Build the image
docker build -t python-data-pipeline .
```

**What happens:**
1. Reads the Dockerfile
2. Starts from `python:3.11-slim` base image (~150MB)
3. Sets working directory to `/app`
4. Copies `requirements.txt` and installs dependencies (numpy, pandas)
5. Copies both `app.py` and `processor.py`
6. Sets `PYTHONUNBUFFERED=1` environment variable
7. Creates Docker image named `python-data-pipeline:latest`

**Verify image was created:**
```bash
docker images

# Output will show:
# REPOSITORY                TAG       IMAGE ID      CREATED        SIZE
# python-data-pipeline      latest    abc123def456  2 minutes ago   456MB
```

### Step 3: Load Image into Kubernetes

#### Option A: Using Minikube (Local)
```bash
# Start Minikube if not running
minikube start

# Load the image into Minikube
minikube image load python-data-pipeline:latest

# Verify it's loaded
minikube image ls | grep python-data-pipeline
```

#### Option B: Using Docker Desktop Kubernetes
- No action needed - image is automatically available
- Kubernetes has direct access to Docker daemon

#### Option C: Using Cloud Kubernetes (AWS EKS, GKE, AKS)
```bash
# Push to Docker Hub
docker tag python-data-pipeline:latest YOUR_USERNAME/python-data-pipeline:latest
docker login
docker push YOUR_USERNAME/python-data-pipeline:latest

# Update image in kubernetes.yaml:
# Change: image: python-data-pipeline:latest
# To:     image: YOUR_USERNAME/python-data-pipeline:latest

# Then deploy (see Step 4)
```

### Step 4: Deploy to Kubernetes
```bash
# Apply the entire kubernetes.yaml manifest
kubectl apply -f kubernetes.yaml
```

**What happens:**
1. **Creates namespace** `python-app` (isolated resource partition)
2. **Creates Deployment 1** (`python-generator`)
   - Pulls image `python-data-pipeline:latest`
   - Starts 1 pod running `python app.py`
   - Generates random numbers every 5 seconds
3. **Creates Deployment 2** (`python-processor`)
   - Pulls same image `python-data-pipeline:latest`
   - Starts 1 pod running `python processor.py`
   - Processes data using pandas every 7 seconds

### Step 5: Verify Deployment was Successful
```bash
# Check if namespace exists
kubectl get namespaces

# Output shows:
# NAME              STATUS   AGE
# python-app        Active   5s
# default           Active   2d
# kube-system       Active   2d

# Check if pods are running
kubectl get pods -n python-app

# Expected output:
# NAME                                READY   STATUS    RESTARTS   AGE
# python-generator-xxxxx-xxxxx        1/1     Running   0          10s
# python-processor-xxxxx-xxxxx        1/1     Running   0          10s

# Check if deployments exist
kubectl get deployments -n python-app

# Expected output:
# NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
# python-generator     1/1     1            1           10s
# python-processor     1/1     1            1           10s
```

### Step 6: View Live Logs

**View generator logs (app.py output):**
```bash
kubectl logs -n python-app -l component=generator -f
```

**Expected output:**
```
[2026-01-13 10:30:45] Hello from Kubernetes! Random numbers: [42 87 15 63 29]
[2026-01-13 10:30:50] Hello from Kubernetes! Random numbers: [71 33 88 19 54]
[2026-01-13 10:30:55] Hello from Kubernetes! Random numbers: [45 62 91 28 76]
```

**View processor logs (processor.py output):**
```bash
kubectl logs -n python-app -l component=processor -f
```

**Expected output:**
```
[2026-01-13 10:30:47] Container 2: Processing data...
[2026-01-13 10:30:47] Mean value: 67.5
[2026-01-13 10:30:47] Status: Service running successfully
```

**View all logs from both pods:**
```bash
kubectl logs -n python-app --all-containers=true -f
```

---

## � File Tree & Detailed Explanation

### How Files Work Together

```
Project Flow:
app.py ─────────┐
processor.py ───┤───→ Dockerfile ───→ Docker Image ───→ kubernetes.yaml ───→ Kubernetes Cluster
requirements.txt┘                    (python-data-pipeline)                 (2 Pods running)
```

### Dockerfile - Image Building

```dockerfile
FROM python:3.11-slim          # Base image
WORKDIR /app                   # Set directory
COPY requirements.txt .        # Copy dependencies file
RUN pip install ...            # Install numpy, pandas
COPY app.py .                  # Copy generator script
COPY processor.py .            # Copy processor script
CMD ["python", "app.py"]       # Default (overridden by K8s)
```

**Why only `app.py` in CMD, not both files?**

A **container/pod can only run ONE main process** at a time. You cannot run two Python scripts simultaneously in a single container. That's why:

- **CORRECT:** `CMD ["python", "app.py"]` - runs ONE file
- **WRONG:** `CMD ["python", "app.py", "processor.py"]` - doesn't work (tries to run both as arguments)

**How does it run both files then?**

The CMD is just a **DEFAULT fallback**. Kubernetes **OVERRIDES** it:

```yaml
# Pod 1 - OVERRIDES CMD to run app.py
command: ["python", "app.py"]

# Pod 2 - OVERRIDES CMD to run processor.py
command: ["python", "processor.py"]
```

**Result:** Creates **2 separate pods** from the **same image**:
- Pod 1: Runs `python app.py` (generates numbers)
- Pod 2: Runs `python processor.py` (processes data)

Both files are copied into the image, but each pod executes a different one.

**Result:** One Docker image containing:
- Python 3.11 runtime
- NumPy 1.24.0 library
- Pandas 2.0.0 library
- app.py script (stored in image, ready to use)
- processor.py script (stored in image, ready to use)

### kubernetes.yaml - Pod Orchestration

```yaml
Namespace: python-app
├── Deployment: python-generator
│   └── Pod: Runs "python app.py" (from image)
│       └── Generates random numbers every 5 seconds
│
└── Deployment: python-processor
    └── Pod: Runs "python processor.py" (from image)
        └── Processes data every 7 seconds
```

**Key Points:**
- Both pods use the **same Docker image** (efficient!)
- Each pod runs a **different command** (app.py vs processor.py)
- Both have **resource limits** (128Mi memory minimum, 256Mi maximum)
- Both can be **scaled independently**

**Visual Comparison: Why 2 Pods?**

```
WRONG WAY - Can't run both in 1 pod:
┌─────────────────────┐
│ Container: python   │
│ Tries to run:       │
│ python app.py       │
│ python processor.py │ ← CAN'T DO THIS!
└─────────────────────┘
(Only ONE main process allowed per container)

CORRECT WAY - 2 Pods with same image:
┌──────────────────┐    ┌──────────────────┐
│ Pod 1: generator │    │ Pod 2: processor │
│                  │    │                  │
│ Runs:            │    │ Runs:            │
│ python app.py    │    │ python processor.│
│                  │    │ py               │
│ Image: python-   │    │ Image: python-   │
│ data-pipeline    │    │ data-pipeline    │
└──────────────────┘    └──────────────────┘
(Both use SAME image, different commands)
```

**Example Flow:**

```
1. Docker Build
   Dockerfile + app.py + processor.py 
   ↓
   Creates: python-data-pipeline image (ONE)
   Contains: both app.py AND processor.py

2. Kubernetes Deploy
   kubernetes.yaml
   ↓
   Pod 1: Executes "python app.py"     (from app.py stored in image)
   Pod 2: Executes "python processor.py" (from processor.py stored in image)
   
   Both pods pull the SAME image
   Both pods have BOTH files in their filesystem
   But each pod runs a DIFFERENT file
```

### File Details Expanded

| File | What's Inside | Purpose | How It's Used |
|------|---------------|---------|---------------|
| **app.py** | Python code using NumPy | Generates random arrays | Copied into Docker image; Pod 1 runs it |
| **processor.py** | Python code using Pandas | Processes data with DataFrame | Copied into Docker image; Pod 2 runs it |
| **requirements.txt** | `numpy==1.24.0` `pandas==2.0.0` | Specifies dependencies | Docker reads it during build; `pip install -r requirements.txt` |
| **Dockerfile** | 10 lines of Docker commands | Recipe to build image | `docker build -t python-data-pipeline .` |
| **kubernetes.yaml** | YAML manifest for K8s | Defines namespace + 2 deployments | `kubectl apply -f kubernetes.yaml` |
| **.gitignore** | Rules for Git | Excludes Python cache, venv, etc. | Git uses it automatically |
| **.dockerignore** | Rules for Docker build | Excludes unnecessary files | Docker uses it during build |

---

## �📊 Monitoring & Debugging Commands

### View All Pods
```bash
kubectl get pods -n python-app
```

### View Detailed Pod Information
```bash
kubectl get pods -n python-app -o wide
```

### View Generator Pod Logs (Real-time)
```bash
kubectl logs -n python-app -l component=generator -f
```

### View Processor Pod Logs (Real-time)
```bash
kubectl logs -n python-app -l component=processor -f
```

### View Logs from Specific Pod
```bash
kubectl logs -n python-app <pod-name> -f
```

Example:
```bash
kubectl logs -n python-app python-generator-xxxxx-xxxxx -f
```

### Get Pod Names
```bash
kubectl get pods -n python-app -o jsonpath='{.items[*].metadata.name}'
```

### Describe a Pod (Troubleshooting)
```bash
kubectl describe pod -n python-app <pod-name>
```

### Execute Command Inside Pod
```bash
kubectl exec -it -n python-app <pod-name> -- /bin/bash
```

### View All Deployments
```bash
kubectl get deployments -n python-app
```

### View Deployment Details
```bash
kubectl describe deployment -n python-app python-generator
```

---

## 🛑 Stop & Clean Up

### Delete Specific Deployment
```bash
kubectl delete deployment python-generator -n python-app
kubectl delete deployment python-processor -n python-app
```

### Delete Entire Namespace (removes all resources)
```bash
kubectl delete namespace python-app
```

### View All Resources in Namespace
```bash
kubectl get all -n python-app
```

---

## 🏗️ Architecture: Kubernetes ONE IMAGE → MULTIPLE PODS

### How It Works

```
IMAGE: python-data-pipeline (ONE - stored in registry)
│
├── Deployment 1: python-generator
│   └── Pod 1: Runs "python app.py"
│
└── Deployment 2: python-processor
    └── Pod 2: Runs "python processor.py"
```

### Key Kubernetes Concepts Used

- **Namespace**: Logical partition (`python-app`) - organizes resources
- **Deployment**: Manages pods and ensures they stay running
- **Pod**: Smallest K8s unit (container wrapper)
- **Image**: Docker image pulled from registry and run in pods
- **Labels**: Identify and query resources (component=generator, etc.)
- **Resource Limits**: CPU and memory constraints

---

## 📈 Scaling Replicas

To run multiple instances of the generator:

```bash
kubectl scale deployment python-generator -n python-app --replicas=3
```

Check replicas are running:
```bash
kubectl get pods -n python-app
```

---

## 🐳 Local Development with Minikube

### Start Minikube
```bash
minikube start
```

### Verify Minikube is Running
```bash
kubectl cluster-info
minikube status
```

### Load Image into Minikube
```bash
minikube image load python-data-pipeline:latest
```

### Deploy
```bash
kubectl apply -f kubernetes.yaml
```

### View Dashboard
```bash
minikube dashboard
```

### Stop Minikube
```bash
minikube stop
```

### Delete Minikube Cluster
```bash
minikube delete
```

---

## Guidelines for Kubernetes Deployment

### Best Practices Followed

1. **Namespace Isolation** - All resources in `python-app` namespace
2. **Single Dockerfile** - Same image used for both pods (efficient)
3. **Resource Limits** - Each pod has CPU/Memory requests and limits
4. **Health Management** - Deployments handle pod restarts automatically
5. **Clear Labels** - Components labeled for easy identification
6. **Simple Configuration** - Single `kubernetes.yaml` for all deployments

### Resource Requests Explained

- **Requests**: Minimum resources guaranteed to pod (K8s scheduling)
- **Limits**: Maximum resources pod can use (prevents runaway)

### Common Troubleshooting

| Issue | Solution |
|-------|----------|
| Pods stuck in Pending | `kubectl describe pod <pod-name>` - check events |
| Pod won't start | `kubectl logs <pod-name>` - check container logs |
| ImagePullBackOff | Ensure image exists: `docker images` or `minikube image load` |
| CrashLoopBackOff | Pod is crashing - check logs for errors |
| Out of memory | Increase limits in kubernetes.yaml |

---

## 📝 Notes

- The same Docker image runs in both pods (just different commands)
- Pods restart automatically if they crash
- Use `kubectl delete namespace python-app` to remove everything
- For production, use cloud registries (Docker Hub, ECR, GCR) instead of local images

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

## 📝 Notes

- Kubernetes pods are stateless - data is lost when pods are deleted (use volumes for persistence)
- Deployments automatically restart failed pods
- Always use namespaces to organize and isolate resources
- Resource limits prevent runaway containers from consuming all cluster resources
- Labels help organize and monitor your applications

---

## 🙏 Thanks & Resources

- **Kubernetes Official Docs:** https://kubernetes.io/docs
- **NumPy Docs:** https://numpy.org/doc
- **Pandas Docs:** https://pandas.pydata.org/docs
- **Minikube Guide:** https://minikube.sigs.k8s.io/docs/start

---

**Project created to learn Kubernetes basics with Python!**
