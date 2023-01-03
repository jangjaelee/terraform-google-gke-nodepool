resource "google_container_node_pool" "gke_nodepool" {
  project  = var.project_id
  cluster  = data.google_container_cluster.gke_cluster_standard.name
  location = var.cluster_location_type


  ####################
  # Node pool basics
  ####################
  name               = var.nodepool_name
  node_count         = lookup(var.autoscaling, "enabled", true) ? null : var.node_count
  node_locations     = var.node_locations
  version            = var.kubernetes_version
  max_pods_per_node  = var.max_pods_per_node
  initial_node_count = lookup(var.autoscaling, "enabled", true) ? (var.initial_node_count != 0 ? var.initial_node_count : var.autoscaling.min_count) : null


  ####################
  # Node configuration
  ####################
  node_config {
    image_type   = var.image_type
    machine_type = var.machine_type
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
    preemptible  = local.enable_preemptible
    spot         = local.enable_spot

    gcfs_config {
      enabled = local.enable_gcfs
    }

    gvnic {
      enabled = var.enable_gvnic
    }

    logging_variant   = var.logging_variant
    boot_disk_kms_key = local.boot_disk_kms_key
    tags              = var.network_tag
  }


  ####################
  # Automation
  ####################
  management {
    auto_repair  = var.node_auto_repair
    auto_upgrade = var.node_auto_upgrade
  }

  dynamic "autoscaling" {
    for_each = var.autoscaling.enabled ? [1] : []
    content {
      min_node_count       = var.autoscaling.min_count
      max_node_count       = var.autoscaling.max_count
      total_min_node_count = var.autoscaling.total_min_count
      total_max_node_count = var.autoscaling.total_max_count
      location_policy      = var.autoscaling.location_policy
    }
  }

  dynamic "upgrade_settings" {
    for_each = var.upgrade_settings.enabled ? [1] : []
    content {
      strategy        = var.upgrade_settings.strategy
      max_surge       = var.upgrade_settings.max_surge
      max_unavailable = var.upgrade_settings.max_unavailable
      dynamic "blue_green_settings" {
        for_each = var.upgrade_settings.strategy == "BLUE_GREEN" ? [1] : []
        content {
          node_pool_soak_duration = var.upgrade_settings.node_pool_soak_duration
          standard_rollout_policy {
            batch_node_count    = var.upgrade_settings.batch_node_count
            batch_percentage    = var.upgrade_settings.batch_percentage
            batch_soak_duration = var.upgrade_settings.batch_soak_duration
          }
        }
      }
    }
  }


  ####################
  # Networking
  ####################
  dynamic "network_config" {
    for_each = var.network_config.enabled ? [1] : []
    content {
      create_pod_range     = var.network_config.create_pod_range
      enable_private_nodes = var.network_config.enable_private_nodes
      pod_ipv4_cidr_block  = var.network_config.pod_ipv4_cidr_block
      pod_range            = var.network_config.pod_range
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = lookup(var.timeouts, "create", "60m")
    update = lookup(var.timeouts, "update", "60m")
    delete = lookup(var.timeouts, "delete", "60m")
  }
}