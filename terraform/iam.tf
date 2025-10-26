# Allow public (unauthenticated) access to the Cloud Run service
resource "google_cloud_run_service_iam_member" "cicd-gha-sa-cr-app_public_invoker" {
  location   = var.region
  project    = var.project_id
  service    = google_cloud_run_service.cicd-gha-sa-cr-app.name
  role       = "roles/run.invoker"
  member     = "allUsers"
  depends_on = [google_cloud_run_service.cicd-gha-sa-cr-app]
}