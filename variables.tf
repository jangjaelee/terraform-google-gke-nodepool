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


####################
# Node configuration
####################


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


