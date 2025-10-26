terraform {
  backend "gcs" {
    bucket = "cicd-gha-tfstate" # use your bucket name
    prefix = "terraform/state"  # folder path within the bucket
  }
}