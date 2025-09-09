variable environment_id {
  type        = string
  description = "ID for the Confluent environment"
  default     = "bsnir-pipelines-env"
}

variable kafka_sa_object {
  description = "kafka_sa_object"
  type  = object({
    id  = string
    api_version = string
    kind = string
  })
  default = {
    id  = ""
    api_version = ""
    kind = ""
  }
}

variable "kafka_cluster_object" {
  description = "kafka_cluster_object"
  type  = object({
    id  = string
    api_version = string
    kind = string
  })
  default = {
    id  = ""
    api_version = ""
    kind = ""
  }
}

variable schema_registry_sa_object {
  description = "schema_registry_sa_object"
  type  = object({
    id  = string
    api_version = string
    kind = string
  })
  default = {
    id  = ""
    api_version = ""
    kind = ""
  }
}

variable flink_admin_sa_object {
  description = "flink_admin_sa_object"
  type  = object({
    id  = string
    api_version = string
    kind = string
  })
  default = {
    id  = ""
    api_version = ""
    kind = ""
  }
}

variable schema_registry_object {
  description = "schema_registry_object"
  type  = object({
    id  = string
    api_version = string
    kind = string
  })
  default = {
    id  = ""
    api_version = ""
    kind = ""
  }
}

variable flink_region_object {
  description = "flink_region_object"
  type  = object({
    id  = string
    api_version = string
    kind = string
  })
  default = {
    id  = ""
    api_version = ""
    kind = ""
  }
}