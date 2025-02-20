# web-deployment-demo

This is a demo project for deploying a web application using Docker and Docker Compose. It is a simple Flask application with a React frontend that just says "Hello, World!". It is containerized with Docker in a multi-stage build to ensure cross-architecture compatibility so that you can run it on an AWS EC2 instance.

## Usage

To pull the image and run the application on your remote server, you can use the following command:

```bash
docker pull emilycogsdill/web-deployment-demo-app:latest
docker run -d -p 3000:3000 emilycogsdill/flask-react-app
```

If you are running this on your machine, you should be able to access the frontend at http://localhost:3000. If you are running on a remote instance, you can confirm it is running by opening a new shell session and running:

```bash
curl -X GET http://localhost:3000
```
If the response is a bunch of html, then the application is running on the correct architecture. 💁‍♀️

## Access the application

Open your browser and navigate to `http://localhost:5000` to see the web application in action.

# Containerizing with Docker

## Multi-Stage Build for Cross-Architecture Compatibility 🚀

This project uses a multi-stage Docker build to enable cross-platform image support for both x86 (amd64) and ARM64 architectures. This is essential when deploying to different cloud environments, such as AWS EC2, where instances may use Intel, AMD, or ARM-based processors (e.g., AWS Graviton).

The Dockerfile uses --platform=$BUILDPLATFORM in the FROM statements to ensure compatibility across different architectures. The final image is then built and pushed using Docker Buildx:

```bash
DOCKERHUB_USERNAME=yourusername
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 \
    -t $DOCKERHUB_USERNAME/web-deployment-demo-app:latest \
    --push .
```

This command creates a multi-architecture image, allowing the same Docker image to run on both Intel/AMD and ARM-based EC2 instances. 💁‍♀️



