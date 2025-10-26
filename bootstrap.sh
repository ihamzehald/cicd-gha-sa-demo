#!/bin/bash
set -e

# =====================================
# GCP Bootstrap, this script expected to run only once,
# prepare & connect the GCP project for Git hub actions
# It does the followng:
# 1- Enable the needed GCP services and APIs
# 2- Creates GHA deployer SA
# 3- Binds the needed IAM permieeions to GHA deployer SA
# 4- Creating Artifact Registry repository to store the docker image build
# 5- Creates a Bucket to be used in TF backend configs to store TF state
# 6- Creates a Service Account key and doeload it to local,
# this needs to be stored in the get repo as secret to authnticate git hub actions with GCP,
# then needs to be deleted from local once stored in github repo config
# =====================================

# =====================================
# ENV CONFIGURATION
# =====================================
PROJECT_ID="gcp-cicd-gha-sa"
REGION="europe-north1"
ARTIFACT_REPO="cicd-gha-sa-images"
SERVICE_ACCOUNT_NAME="cicd-gha-sa-deployer"
BUCKET_NAME="cicd-gha-tfstate"
IMAGE_NAME="cicd-gha-sa-image"
SERVICE_NAME="cicd-gha-sa-service"
# =====================================

echo "Activating project..."
gcloud config set project "$PROJECT_ID"

echo "Enabling required APIs..."
gcloud services enable \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  run.googleapis.com \
  iam.googleapis.com \
  serviceusage.googleapis.com \
  storage.googleapis.com

echo "Creating service account..."
gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" \
  --display-name="GitHub Actions Deployer" || echo "Service account may already exist"

SA_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "Granting IAM roles to service account..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/artifactregistry.admin"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/storage.admin"

echo "Creating Artifact Registry repository (if not exists)..."
gcloud artifacts repositories create "$ARTIFACT_REPO" \
  --repository-format=docker \
  --location="$REGION" \
  --description="Docker images for Cloud Run" || echo "Repository already exists."

echo "Creating Service Account key..."
gcloud iam service-accounts keys create ./gcp-sa-key.json \
  --iam-account="${SA_EMAIL}"

# Create TF state bucket
gcloud storage buckets create gs://${BUCKET_NAME} \
  --project=${PROJECT_ID} \
  --location=${REGION} \
  --uniform-bucket-level-access

# Optional: add versioning (so you can roll back changes)
gcloud storage buckets update gs://${BUCKET_NAME} --versioning

echo "============================================"
echo "✅ GCP bootstrap complete!"
echo ""
echo "Upload the JSON key (gcp-sa-key.json) to your GitHub repo secrets:"
echo "  Name: GCP_SA_KEY"
echo "  Value: (paste file content)"
echo ""
echo "Then set your repository variables, to be used in github/workflows/deploy.yml:"
echo "  PROJECT_ID = ${PROJECT_ID}"
echo "  REGION = ${REGION}"
echo "  ARTIFACT_REPO = ${ARTIFACT_REPO}"
echo "  IMAGE_NAME = ${IMAGE_NAME}"
echo "  SERVICE_NAME = ${SERVICE_NAME}"
echo ""
echo "You're ready to deploy via GitHub Actions 🚀"
echo "============================================"
