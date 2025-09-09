variable environment_id {
  type        = string
  description = "ID for the Confluent environment"
  default     = "bsnir-pipelines-env"
}

variable environment_resource_name {
  type        = string
  description = "Name for the Confluent environment"
  default     = "bsnir-pipelines-env"
}

variable kafka_cluster_id {
  type        = string
  default     = ""
  description = "Kafka Cluster ID"
}

variable kafka_resource_crn {
  type        = string
  default     = ""
  description = "Kafka RBAC resource CRN"
}

variable kafka_cluster_sa_id {
  type        = string
  default     = ""
  description = "Service account ID for Kafka cluster"
}

variable role_sa_kafka {
  type        = string
  default     = ""
  description = "The Role name to bind to the principal"
}

variable schema_registry_sa_id {
  type        = string
  default     = ""
  description = "Service account ID for Schema Registry"
}

variable schema_registry_resource_name {
  type        = string
  default     = ""
  description = "Schema Registry resource name"
}

variable role_sa_schema_registry {
  type        = string
  default     = ""
  description = "The Role name to bind to the principal"
}

variable role_sa_flink_admin {
  type        = string
  default     = ""
  description = "The Role name to bind to the principal"
}

variable flink_admin_sa_id {
  type        = string
  default     = ""
  description = "Service account ID for Flink Admin"
}