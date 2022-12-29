data "google_container_cluster" "gke_cluster_standard" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.cluster_location_type
}