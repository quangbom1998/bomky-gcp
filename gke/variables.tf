variable "project_id" {
  type    = string
  default = "bomky-357603"
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "bomky-cluster"
}
variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "dev"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-services"
}