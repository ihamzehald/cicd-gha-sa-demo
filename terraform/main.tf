resource "google_cloud_run_service" "cicd-gha-sa-cr-app" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image_uri
        ports {
          container_port = 8080
        }

        env {
          name  = "SERVICE_NAME"
          value = var.service_name
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

