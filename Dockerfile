# Dockerfile for Python Kubernetes Application

# BASE IMAGE - Use lightweight Python 3.11 slim image
# slim variant: ~150MB (smaller than full python:3.11)
FROM python:3.11-slim

# SET WORKING DIRECTORY inside the container
WORKDIR /app

# COPY REQUIREMENTS FILE from host to container
COPY requirements.txt .

# INSTALL PYTHON DEPENDENCIES from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# COPY APPLICATION FILES
COPY app.py .
COPY processor.py .

# SET ENVIRONMENT VARIABLE
ENV PYTHONUNBUFFERED=1

# DEFAULT COMMAND to run when container starts
CMD ["python", "app.py"]
