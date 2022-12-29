resource "google_container_node_pool" "gke_nodepool" {
  project  = var.project_id
  cluster  = data.google_container_cluster.gke_cluster_standard.name
  location = var.cluster_location_type

  name           = var.nodepool_name
  node_count     = var.node_count
  node_locations = var.node_locations
  #initial_node_count = var.initial_node_count
  version = var.kubernetes_version

  management {
    auto_repair  = var.node_auto_repair
    auto_upgrade = var.node_auto_upgrade
  }

  # upgrade_settings {
  #   max_surge       = 
  #   max_unavailable = 
  #   strategy        = 

  #   blue_green_settings {
  #     node_pool_soak_duration = 
  #     standard_rollout_policy {
  #       batch_node_count    = 
  #       batch_percentage    = 
  #       batch_soak_duration = 
  #     }
  #   }
  # }
}