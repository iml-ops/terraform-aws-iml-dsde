variable "name" {
  type        = string
  description = "The name of the deployment. This will be used for naming resources."
  default     = "iml-dsde"
}

variable "region" {
  type        = string
  description = "The AWS region to deploy to."
}

variable "network_cidr" {
  type        = string
  description = "The CIDR block for the network."
}

variable "boundary_cluster_id" {
  type        = string
  description = "The ID of the Boundary cluster."
}

variable "gateway_token" {
  type        = string
  description = "The token for the gateway."
}
