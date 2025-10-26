variable "region" {
  type    = string
  default = "europe-north1"
}

variable "service_name" {
  type    = string
  default = "cicd-gha-sa-service"
}

variable "artifact_repo" {
  type    = string
  default = "cicd-gha-sa-images"
}

variable "image_uri" {
  type        = string
  description = "Full image URL including tag or digest, passed from Terraform apply"
}

variable "ingress" {
  type    = string
  default = "INGRESS_TRAFFIC_ALL" # or INGRESS_TRAFFIC_INTERNAL_ONLY
}

variable "allow_unauthenticated" {
  type    = bool
  default = true
}

variable "project_id" {
  type    = string
  default = "gcp-cicd-gha-sa"
}
