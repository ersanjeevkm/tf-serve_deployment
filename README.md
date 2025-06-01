# TensorFlow Serving Deployment for Clothing Classification

This repository demonstrates the deployment of a TensorFlow model for clothing classification using TensorFlow Serving, containerization, and Kubernetes orchestration.

## Project Overview

**Model**: Fine-tuned Xception model that classifies clothing types (10 categories: dress, hat, longsleeve, outwear, pants, shirt, shoes, shorts, skirt, t-shirt)

**Architecture**:
- **TensorFlow Serving**: Serves the trained model via gRPC
- **Flask Gateway**: Handles HTTP requests, preprocesses images, and communicates with the model server
- **Containerization**: Both applications are dockerized for consistent deployment
- **Orchestration**: Kubernetes deployment with services for production-ready scaling

## Quick Start with Docker Compose

For local testing and development:

```bash
# Build Docker images
docker build -t gateway:v1.0 -f image-gateway.dockerfile .
docker build -t image-model:v1.0 -f image-model.dockerfile .

# Start services
docker-compose up

# Test the service
python test.py
```

## Kubernetes Deployment

### Prerequisites

Ensure you have the following tools installed:
- Docker
- kubectl
- kind (Kubernetes in Docker)

### Setup Instructions

1. **Create a Kind cluster**:
   ```bash
   kind create cluster
   ```

2. **Build and load Docker images**:
   ```bash
   # Build images
   docker build -t gateway:v1.0 -f image-gateway.dockerfile .
   docker build -t image-model:v1.0 -f image-model.dockerfile .
   
   # Load images into Kind cluster
   kind load docker-image gateway:v1.0
   kind load docker-image image-model:v1.0
   ```

3. **Deploy to Kubernetes**:
   ```bash
   cd kube-config
   
   # Deploy model serving
   kubectl apply -f model-deployment.yaml
   kubectl apply -f model-service.yaml
   
   # Deploy gateway
   kubectl apply -f gateway-deployment.yaml
   kubectl apply -f gateway-service.yaml
   ```

4. **Verify deployment**:
   ```bash
   kubectl get pods
   kubectl get services
   ```

5. **Test the deployment**:
   ```bash
   # Forward port to access the service locally
   kubectl port-forward service/gateway 5555:80
   
   # Run test script
   python test.py
   ```

## Architecture Details

### Services Configuration

- **Gateway Service**: 
  - Type: LoadBalancer (external access)
  - Exposes port 80, forwards to container port 5555
  - Connects to model service via internal cluster communication

- **Model Service**: 
  - Type: ClusterIP (internal only)
  - Exposes port 8500 for gRPC communication
  - Accessed by gateway via service discovery

### Container Resources

- **Gateway**: 256Mi memory, 0.5 CPU
- **Model Server**: 512Mi memory, 1 CPU

## API Usage

Send POST requests to `/predict` endpoint with image URL:

```json
{
  "url": "http://example.com/image.jpg"
}
```

Response contains classification probabilities for all clothing categories.

## Development Notes

This setup prioritizes simplicity and is suitable for development and small-scale deployments. For production use, consider adding:
- Ingress controller for advanced routing
- Horizontal Pod Autoscaler (HPA) for automatic scaling
- Resource quotas and limits
- Health checks and monitoring
- Persistent storage for model versioning

## File Structure

```
tf-serve_deployment/
├── README.md
├── requirements.txt
├── gateway.py                    # Flask application
├── test.py                      # Testing script
├── docker-compose.yaml          # Local development setup
├── image-gateway.dockerfile     # Gateway container
├── image-model.dockerfile       # Model serving container
├── clothing-model/              # TensorFlow SavedModel
└── kube-config/                 # Kubernetes manifests
    ├── gateway-deployment.yaml
    ├── gateway-service.yaml
    ├── model-deployment.yaml
    └── model-service.yaml
```