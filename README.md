# cicd-gha-sa-demo

CI/CD GitHub Actions using GCP Service Account authentication.

# Setup Steps

The current CI/CD pipeline in this repository is failing — and that’s expected, since it is not yet configured for a GCP project.  
To make the CI/CD pipeline pass, clone the project and push it to your own GitHub account (make the repo private),  
then follow the steps below.

**Step #1:** Configure your GCP project and link it to a billing account.

**Step #2:** In your terminal, navigate to the project root folder and run the bootstrap script (`./bootstrap.sh`).  
This script will execute the necessary `gcloud` commands to set up your GCP project with your GitHub Actions workflow.  
It will do the following:

1. Enable the required GCP services and APIs  
2. Create a GitHub Actions deployer Service Account  
3. Bind the required IAM permissions to the deployer Service Account  
4. Create an Artifact Registry repository to store Docker images  
5. Create a Cloud Storage bucket to be used by Terraform backend for storing state  
6. Create a Service Account key and download it locally  
   - Store this key in the GitHub repo as a secret to authenticate GitHub Actions with GCP  
   - Delete the local file once it has been added to GitHub

**Step #3:** Finally, edit the environment variables in the `.sh` script as needed, then follow the instructions displayed after it completes to configure your repository.  
Once you’ve configured the repo secrets and environment variables as described, commit and push to the `main` branch to verify that the CI/CD pipeline builds successfully.
