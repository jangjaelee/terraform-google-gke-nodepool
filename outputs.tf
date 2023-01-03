output "gke_cluster_standard_id" {
  value = data.google_container_cluster.gke_cluster_standard.id
}

output "gke_cluster_standard_endpoint" {
  value = data.google_container_cluster.gke_cluster_standard.endpoint
}

output "gke_cluster_standard_selflink" {
  value = data.google_container_cluster.gke_cluster_standard.self_link
}

output "boot_disk_kms_key" {
  value = local.boot_disk_kms_key
}