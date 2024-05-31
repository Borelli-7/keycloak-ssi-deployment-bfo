variable "aws_region" {
  description = "The AWS region for creating the infrastructure"
  default     = "eu-central-1"
}

variable "ecs_cluster_name" {
  default = "ecs_keycloak_cluster"
}

variable "ecs_log_level" {
  description = "The ECS log level"
  default     = "info"
}

variable "keycloak_admin_username" {
  description = "Keycloak username"
  default     = "<user-name>"
}

variable "rds_username" {
  description = "Postgres username"
  default     = "<user-name>"
}

variable "public_dns_name" {
  description = "public DNS Name"
  default     = "<public-dns>"
}

variable "zone_name" {
  description = "Route 53 zone name"
  default     = "<zone-name>"
}