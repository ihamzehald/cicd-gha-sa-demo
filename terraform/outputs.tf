output "service_url" {
  value = google_cloud_run_service.cicd-gha-sa-cr-app.status[0].url
}