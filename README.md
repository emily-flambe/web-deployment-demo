# web-deployment-demo

This is a demo project for deploying a web application using Docker and Docker Compose. It is a simple Flask application with one endpoint, '/api/hello', that says "Hello, World!". It is containerized with Docker in a multi-stage build to ensure cross-architecture compatibility so that you can run it on an AWS EC2 instance.

For demonstration purposes, this application includes only a backend with no frontend. This keeps the build process simple and the application lightweight, as the intended purpose of this demo is to show how to deploy a containerized web application to the internet on an AWS EC2 instance. Implementation of a frontend interface (e.g., a React app) is trivial and left as an exercise for the reader.

This demo, unimpressive as it is, is live on the public internet at https://demo-web-app.emilyflam.be, wherein is contained but a single API endpoint: https://demo-web-app.emilyflam.be/api/hello.

## Usage

To pull the image and run the application on your remote server, you can use the following command:

```bash
docker pull emilycogsdill/web-deployment-demo-app:latest
docker run -d -p 5000:5000 emilycogsdill/web-deployment-demo-app:latest
```

If you are running this on your machine, you should be able to access the API at http://localhost:5000/api/hello. If you are running on a remote instance, you can confirm it is running by opening a new shell session and running:

```bash
curl -X GET http://localhost:5000/api/hello
```
If the response is `{"message":"Hello, World!"}`, then the application is running successfully. 💁‍♀️

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



