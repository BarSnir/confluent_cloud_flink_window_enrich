variable "region" {
  description = "Region for demo"
  type        = string
  default     = "eu-west-1"
}

variable "cloud" {
  description = "Cloud provider for demo"
  type        = string
  default     = "AWS"
}

variable sr_api_key_description {
    description = "Region for the Kafka cluster"
    type        = string
    default     = "API keys for schema creation"
}

variable flink_admin_service_account_description {
    description = "Flink Admin"
    type        = string
    default     = "API keys for schema creation"
}