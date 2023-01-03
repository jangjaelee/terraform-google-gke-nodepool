locals {
  module_name    = "terraform-google-gke-nodepool"
  module_version = "v0.0.1"

  # PREEMPTIBLE flag for enabling preemptible VM.
  enable_preemptible = var.spot_preemptible == "PREEMPTIBLE" ? true : false

  # SPOT flag for enabling Spot VM, which is a rebrand of the existing preemptible flag.
  enable_spot = var.spot_preemptible == "SPOT" ? true : false

  enable_gcfs  = var.image_type == "COS_CONTAINERD" && var.enable_gcfs == true ? true : false
  enable_gvnic = var.image_type == "COS_CONTAINERD" && var.enable_gvnic == true ? true : false

  boot_disk_kms_key = length(var.boot_disk_kms_key) != 0 ? format("projects/%s/locations/%s/keyRings/%s/cryptoKeys/%s", var.boot_disk_kms_key.project-id, var.boot_disk_kms_key.location, var.boot_disk_kms_key.ring-name, var.boot_disk_kms_key.key-name) : null
} 