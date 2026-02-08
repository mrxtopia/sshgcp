#!/bin/bash

# Configuration
PROJECT_ID=$(gcloud config get-value project)
INSTANCE_NAME="ssh-server-instance"
ZONE="us-central1-a"
IMAGE_NAME="ssh-server"
REPOSITORY="my-repo" # Assumes artifact registry repo is created
LOCATION="us-central1"

echo "Using Project ID: $PROJECT_ID"

# 1. Build and Push (Optional if using Container-Optimized OS)
# However, usually for GCP we push to Artifact Registry
echo "Building Docker image..."
docker build -t $IMAGE_NAME .

# 2. Tag and Push (Requires Artifact Registry)
# gcloud artifacts repositories create $REPOSITORY --repository-format=docker --location=$LOCATION
# docker tag $IMAGE_NAME $LOCATION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME
# docker push $LOCATION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME

# 3. Create GCE Instance with the container
# This uses the Container-Optimized OS and runs the docker image directly
echo "Creating GCE Instance..."
gcloud compute instances create-with-container $INSTANCE_NAME \
    --container-image=$LOCATION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME \
    --zone=$ZONE \
    --machine-type=e2-micro \
    --tags=allow-ssh-port \
    --container-restart-policy=always

# 4. Create Firewall rule
echo "Creating Firewall rule..."
gcloud compute firewall-rules create allow-ssh-22 \
    --allow tcp:22 \
    --target-tags=allow-ssh-port \
    --description="Allow SSH traffic on port 22"

echo "Deployment finished. You can connect using: ssh mrxtopia@<INSTANCE_EXTERNAL_IP>"
