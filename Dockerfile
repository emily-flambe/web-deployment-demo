# Step 1: Build React Frontend
FROM --platform=$BUILDPLATFORM node:18 AS frontend-build
WORKDIR /app/frontend

# Copy package files and install dependencies
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm install

# Copy the rest of the frontend code and build it
COPY frontend/ . 
RUN npm run build

# Step 2: Build Flask Backend
FROM --platform=$BUILDPLATFORM python:3.10 AS backend-build
WORKDIR /app
COPY backend/ /app/backend

# Copy frontend build output into backend
COPY --from=frontend-build /app/frontend/build /app/backend/static

# Install uv package manager
RUN pip install uv

# Install dependencies using uv
COPY backend/pyproject.toml /app/backend/
RUN cd /app/backend && uv pip install --system --requirements pyproject.toml

# Step 3: Final Image (Ensure Flask is Installed)
FROM python:3.10-slim
WORKDIR /app
COPY --from=backend-build /app/backend /app/backend
COPY --from=frontend-build /app/frontend /app/frontend

# Install Gunicorn, Flask & Node.js
RUN pip install uv && uv pip install --system flask flask-cors gunicorn
RUN apt-get update && apt-get install -y nodejs npm

# Expose ports for Flask (5000) & React (3000)
EXPOSE 5000 3000

# Start both Flask backend & React frontend
CMD ["bash", "-c", "gunicorn -b 0.0.0.0:5000 backend.app:app & cd /app/frontend && npm start"]
