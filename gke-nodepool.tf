resource "google_container_node_pool" "gke_nodepool" {
  project = var.project_id
  cluster = data.google_container_cluster.gke_cluster_standard.name

  name          = var.nodepool_name
  node_count    = var.node_count
  node_locations = var.node_locations
  version = "1.24.5-gke.600"


}