# tf-serve_deployment


This is a repo for deployment of a tf model 
- tf model: xception model finetuned to classify the types of cloths (shirt, pants)
- Model serving using tf-serve
- Gateway app built using flask (preprocessing and connection to model server using grpc internal)
- Dockerized both application model-serve image and gateway flask image
- local testing using docker compose

Deplyment using Kubernetes:
- gateway service (External/Load balancer) and deployment
- tf-serving service(Internal/Cluster IP) and deplyment
- Keeping it simple, bcz single external service no ingress and no HPA - pod scaler
- Kind for creating a kubernetes cluster in docker


TODO:
Update setup instructions
Docker image creation and kubectly apply -f information

make sure you have kind, docker and kubectl installed
Create a cluster on kind
kind create cluster

create docker images
docker build -t image-model:v1.0 -f image-gateway.dockerfile .
docker build -t gateway:v1.0 -f image-model.dockerfile .

docker-compose:
docker-compose up

load images to kind
kind load docker-image gateway:v1.0
kind load docker-image image-model:v1.0

cd kube-config
deployments:
kubectl apply -f model-deployment.yaml
kubectl apply -f gateway-deployment.yaml

services:
kubectl apply -f model-service.yaml (internal)
kubectl apply -f gateway-service.yaml (external, connected to model service via cluster ip)

kubectl get pods
kubectl get svc

test external service
kubectl port-forward service/gateway 5555:80

test it using test.py

