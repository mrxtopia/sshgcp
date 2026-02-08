#!/bin/bash

# Configuration
PROJECT_ID=$(gcloud config get-value project)
SERVICE_NAME="web-ssh-service"
REGION="us-central1"
IMAGE_NAME="web-ssh"
REPOSITORY="my-repo" # Assumes artifact registry repo is created

echo "Using Project ID: $PROJECT_ID"

# 1. Build the image
echo "Building Docker image..."
IMAGE_TAG="$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME"
docker build -t $IMAGE_TAG .

# 2. Push to Artifact Registry
echo "Pushing image..."
docker push $IMAGE_TAG

# 3. Deploy to Cloud Run
echo "Deploying to Cloud Run..."
gcloud run deploy $SERVICE_NAME \
    --image $IMAGE_TAG \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --port 8080

echo "Deployment finished. Access your Web SSH at the URL above."
