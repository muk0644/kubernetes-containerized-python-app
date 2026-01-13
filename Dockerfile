# Dockerfile for Python Docker Application


# BASE IMAGE - Use lightweight Python 3.11 slim image
# slim variant: ~150MB (smaller than full python:3.11)
# full variant would be ~900MB
FROM python:3.11-slim

# SET WORKING DIRECTORY inside the container
# All subsequent commands will run in /app folder
# Think of it as 'cd /app' in Linux
WORKDIR /app

# EXPOSE PORT 5000 (optional, for reference)
# This tells Docker which port the app uses
# NOTE: This is just documentation - doesn't actually open the port
# To actually expose it, use: docker run -p 5000:8000
# Syntax: -p <host-port>:<container-port>
EXPOSE 5000

# COPY REQUIREMENTS FILE from host to container
# This allows us to install dependencies before copying app code
# This creates a better Docker layer cache
COPY requirements.txt .

# INSTALL PYTHON DEPENDENCIES from requirements.txt
# RUN executes command inside the container during build
# pip install installs packages listed in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# COPY APPLICATION FILES
# Copy both app.py and processor.py to the container
# Each container will run a different script specified in docker-compose.yml
COPY app.py .
COPY processor.py .

# SET ENVIRONMENT VARIABLE (optional but good practice)
# PYTHONUNBUFFERED=1 ensures Python output is sent directly to logs
# Without this, output might be buffered and delayed
ENV PYTHONUNBUFFERED=1

# DEFAULT COMMAND to run when container starts
# This will be overridden by docker-compose.yml for each container
CMD ["python", "app.py"]

# ============================================
# BUILD COMMAND:
# docker build -t python-docker-app .
#
# RUN COMMAND (foreground):
# docker run -it python-docker-app
#
# RUN COMMAND (background):
# docker run -d --name my-app python-docker-app
#
# RUN WITH PORT MAPPING (if app uses ports):
# docker run -p 5000:5000 python-docker-app
#
# VIEW LOGS:
# docker logs my-app
#
# STOP CONTAINER:
# docker stop my-app
