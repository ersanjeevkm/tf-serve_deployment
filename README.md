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