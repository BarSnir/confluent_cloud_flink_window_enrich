
variable "environment_id"       { type = string }
variable "environment_name"     { type = string }
variable "kafka_cluster_name"   { type = string }

variable "flink_service_account" { type = string }
variable "flink_compute_pool_id" { type = string }
variable "flink_rest_endpoint"   { type = string }

variable "flink_api_key"    { type = string }

variable "flink_api_secret" { 
    type = string
    sensitive = true  
}