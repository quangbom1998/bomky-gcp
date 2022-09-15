# Node Serivce Account
resource "google_service_account" "default" {
  account_id   = "bomky-gke-node-sa"
  display_name = "GKE Node Service Account"
}

locals {
  all_service_account_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader",
    "roles/storage.objectViewer"
  ]
}

resource "google_project_iam_member" "sa-roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.default.email}"
}
