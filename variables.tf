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

variable "spot_preemptible" {
  description = "Whether the nodes are created as preemptible or spot VM instances. choose SPOT or PREEMPTIBLE. Default is 'null'."
  type        = string
  default     = null # null or SPOT or PREEMPTIBLE
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

variable "logging_variant" {
  description = "LoggingVariantConfig specifies the behaviour of the logging component. Valid values include DEFAULT and MAX_THROUGHPUT."
  type        = string
  default     = "DEFAULT" # DEFAULT or MAX_THROUGHPUT
}

variable "boot_disk_kms_key" {
  description = "The Customer Managed Encryption Key used to encrypt the boot disk attached to each node in the node pool."
  type        = map(string)
  default     = {}
  # default     = {
  #   "project-id" = "abc",
  #   "location" = "test",
  #   "ring-name" = "ring",
  #   "key-name" = "keyname"
  # }
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

variable "autoscaling" {
  description = "Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage."
  type = object({
    enabled         = bool   # autoscaling is true
    min_count       = number # Minimum number of nodes in the NodePool. Must be >=0 and <= max_count. Cannot be used with total limits.
    max_count       = number # Maximum number of nodes in the NodePool. Must be >= min_count. Cannot be used with total limits.
    total_min_count = number # Total minimum number of nodes in the NodePool. Must be >=0 and <= total_max_node_count. Cannot be used with per zone limits.
    total_max_count = number # Total maximum number of nodes in the NodePool. Must be >= total_min_node_count. Cannot be used with per zone limits.
    location_policy = string # Location policy specifies the algorithm used when scaling-up the node pool. "BALANCED" - Is a best effort policy that aims to balance the sizes of available zones. "ANY" - Instructs the cluster autoscaler to prioritize utilization of unused reservations, and reduce preemption risk for Spot VMs.
  })
  default = {
    enabled         = false
    min_count       = 1
    max_count       = 10
    total_min_count = null
    total_max_count = null
    location_policy = null
  }
}

variable "upgrade_settings" {
  description = "These upgrade settings control the level of parallelism and the level of disruption caused by an upgrade."
  type = object({
    enabled                 = bool   # upgrade_settings is true
    strategy                = string # Strategy used for node pool update. Strategy can only be one of BLUE_GREEN or SURGE. The default is value is SURGE.
    max_surge               = number # The maximum number of nodes that can be created beyond the current size of the node pool during the upgrade process. To be used when strategy is set to SURGE. Default is 0. 
    max_unavailable         = number # The maximum number of nodes that can be simultaneously unavailable during the upgrade process. To be used when strategy is set to SURGE. Default is 0.
    node_pool_soak_duration = string # Time needed after draining entire blue pool. After this period, blue pool will be cleaned up. A duration in seconds with up to nine fractional digits, ending with 's'.
    batch_percentage        = number # Percentage of the bool pool nodes to drain in a batch. The range of this field should be (0.0, 1.0).
    batch_node_count        = number # Number of blue nodes to drain in a batch. Only one of the batch_percentage or batch_node_count can be specified.
    batch_soak_duration     = string # Soak time after each batch gets drained. A duration in seconds with up to nine fractional digits, ending with 's'.
  })
  default = {
    enabled                 = true
    strategy                = "SURGE" # # SURGE or BLUE_GREEN
    max_surge               = 1
    max_unavailable         = 0
    node_pool_soak_duration = null
    batch_percentage        = null
    batch_node_count        = null
    batch_soak_duration     = null
  }
}


####################
# Networking
####################
variable "network_config" {
  description = "Parameters for node pool-level network config."
  type = object({
    enabled              = bool   #
    create_pod_range     = bool   # Whether to create a new range for pod IPs in this node pool. Defaults are provided for podRange and podIpv4CidrBlock if they are not specified.
    enable_private_nodes = bool   # Whether nodes have internal IP addresses only. If enablePrivateNodes is not specified, then the value is derived from [cluster.privateClusterConfig.enablePrivateNodes][google.container.v1beta1.PrivateClusterConfig.enablePrivateNodes]
    pod_ipv4_cidr_block  = string # The IP address range for pod IPs in this node pool. Only applicable if createPodRange is true. Set to blank to have a range chosen with the default size.
    pod_range            = string # The ID of the secondary range for pod IPs. If createPodRange is true, this ID is used for the new range. If createPodRange is false, uses an existing secondary range with this ID.
  })
  default = {
    enabled              = false
    create_pod_range     = false
    enable_private_nodes = false
    pod_ipv4_cidr_block  = null
    pod_range            = null
  }
}

variable "network_tag" {
  description = "The list of instance tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls and are specified by the client during cluster or node pool creation. Each tag within the list must comply with RFC1035."
  type        = list(any)
  default     = null
}


####################
# Security
####################


####################
# Service Account
####################


