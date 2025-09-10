variable "environment_id" {
  description = "Confluent Cloud Environment ID"
  type        = string
}

variable "environment_display_name" {
  description = "Confluent Cloud Environment Display Name"
  type        = string
}

variable "kafka_cluster_display_name" {
  description = "Confluent Cloud Kafka Cluster Display Name"
  type        = string
}

variable "flink_rest_endpoint" {
  description = "Flink Compute Pool REST Endpoint"
  type        = string
}

variable "flink_admin_sa_object" {
  description = "Flink Admin Service Account Object"
  type        = any
}

variable "flink_compute_pool_id" {
  description = "Flink Compute Pool ID"
  type        = string
}

variable flink_api_key {
  type        = string
  default     = ""
  description = " The Role name to bind to the principal"
}

variable flink_api_secret {
  type        = string
  default     = ""
  description = " The Role name to bind to the principal"
}

variable catalog {
  type        = string
  default     = "bsnir_pipelines_env"
  description = "Catalog name for the SQL queries"
}

variable database {
  type        = string
  default     = "bsnir_tf_standard_cluster"
  description = "Database name for the SQL queries"
}