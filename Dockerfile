# Step 1: Build Flask Backend
FROM --platform=$BUILDPLATFORM python:3.10 AS backend-build
WORKDIR /app

# Copy backend code
COPY backend/ /app/backend

# Install uv package manager
RUN pip install uv

# Install dependencies using uv
COPY backend/pyproject.toml /app/backend/
RUN cd /app/backend && uv pip install --system --requirements pyproject.toml

# Step 2: Final Image (Flask Only)
FROM python:3.10-slim
WORKDIR /app

# Copy backend from the previous build stage
COPY --from=backend-build /app/backend /app/backend

# Install Gunicorn and Flask
RUN pip install uv && uv pip install --system flask flask-cors gunicorn

# Expose Flask's default port
EXPOSE 5000

# Start Flask using Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "backend.app:app"]
