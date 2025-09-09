variable region {
  type        = string
  description = "ID for the Confluent environment"
  default     = "eu-west-1"
}

variable cloud_provider {
  type        = string
  description = "ID for the Confluent environment"
  default     = "AWS"
}

variable role_sa_kafka {
  type        = string
  description = "The Role name to bind to the principal"
  default     = "CloudClusterAdmin"
}

variable role_sa_schema_registry {
  type        = string
  default     = "ResourceOwner"
  description = "The Role name to bind to the principal"
}

variable role_sa_flink_admin {
  type        = string
  default     = "EnvironmentAdmin"
  description = "The Role name to bind to the principal"
}