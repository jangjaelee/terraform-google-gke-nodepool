variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "region" {
  description = "The default region to manage resources in."
  type        = string
}

variable "validate_labels" {
  description = "validate labels"
  type        = map(string)
}

# variable "resource_labels" {
#   description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
#   type        = map(string)
# }

variable "timeouts" {
  description = "Timeout for cluster operations."
  type        = map(string)
}


####################
# Cluster basics
####################
variable "cluster_name" {
  description = "The name of the cluster, unique within the project and location."
  type        = string
}

variable "cluster_location_type" {
  description = "The location (region or zone) in which the cluster master will be created. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the nodes."
  type        = string
}

####################
# Node pool basics
####################
variable "nodepool_name" {
  description = "he name of the node pool. If left blank, Terraform will auto-generate a unique name."
  type        = string
}

variable "node_count" {
  description = "The number of nodes per instance group. This field can be used to update the number of nodes per instance group but should not be used alongside autoscaling."
  type        = number
}

variable "node_locations" {
  description = "The list of zones in which the node pool's nodes should be located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. If unspecified, the cluster-level node_locations will be used."
  type        = list(string)
}

variable "initial_node_count" {
  description = "The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource."
  type        = number
}

variable "max_pods_per_node" {
  description = "The maximum number of pods per node in this node pool. default 110 and maximum up to 256"
  type        = number
  default     = 110
}


####################
# Node configuration
####################
variable "image_type" {
  description = "The image type to use for this node. Note that changing the image type will delete and recreate all nodes in the node pool.  COS_CONTAINERD or UBUNTU_CONTAINERD."
  type        = string
  default     = "COS_CONTAINERD"
}

variable "machine_type" {
  description = "The name of a Google Compute Engine machine type. Defaults to e2-medium."
  type        = string
}

variable "disk_type" {
  description = "Type of the disk attached to each node (e.g. 'pd-standard', 'pd-balanced' or 'pd-ssd'). If unspecified, the default disk type is 'pd-standard'"
  type        = string
}

variable "disk_size_gb" {
  description = "Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB. Defaults to 100GB."
  type        = number
}

variable "enable_gcfs" {
  description = "If unspecified, GCFS will not be enabled on the node pool. When enabling this feature you must specify image_type = 'COS_CONTAINERD' and node_version from GKE versions 1.19 or later to use it. A machine_type that has more than 16 GiB of memory is also recommended."
  type        = bool
  default     = false
}

variable "enable_gvnic" {
  description = "Google Virtual NIC (gVNIC) is a virtual network interface. gVNIC is an alternative to the virtIO-based ethernet driver. GKE nodes must use a Container-Optimized OS node image."
  type        = bool
  default     = false
}


####################
# Automation
####################
variable "node_auto_repair" {
  description = "Whether the nodes will be automatically repaired."
  type        = bool
}

variable "node_auto_upgrade" {
  description = "Whether the nodes will be automatically upgraded."
  type        = bool
}




####################
# Networking
####################

####################
# Security
####################


####################
# Service Account
####################


