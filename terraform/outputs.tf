output "environment_id" {
  description = "Environment ID"
  value       = module.cores.module_environment.environment_id
}

output "kafka_bootstrap_endpoint" {
  description = "Kafka Bootstrap Endpoint"
  value       = module.cores.module_kafka.kafka_bootstrap_endpoint
}

output "schema_registry_rest_endpoint" {
  description = "Connectors API Key"
  value       = module.cores.module_schema_registry.schema_registry_object.rest_endpoint
}

output "flink_compute_pool_id" {
  description = "Flink Compute Pool ID"
  value       = module.cores.module_flink_compute_pool.flink_compute_pool.id
}

output "flink_service_account_id" {
  description = "Flink Service Account ID"
  value       = module.cores.module_service_accounts.flink_admin_sa_object.id
}

output "flink_rest_endpoint" {
  description = "Kafka Service Account ID"
  value       =   module.cores.module_flink_compute_pool.flink_region_object.rest_endpoint
}

output "connectors_api_key" {
  description = "Connectors API Key"
  value       = module.cores.module_api_keys.connectors_api_key
}

output "connectors_api_secret" {
  description = "Connectors API Secret"
  value       = module.cores.module_api_keys.connectors_api_secret
  sensitive   = true
}

output "schema_registry_api_key" {
  description = "Schema Registry API Key"
  value       = module.cores.module_api_keys.schema_registry_api_key
}

output "schema_registry_api_secret" {
  description = "Schema Registry API Secret"
  value       = module.cores.module_api_keys.schema_registry_api_secret
  sensitive   = true
}

output "flink_api_key" {
  description = "Schema Registry API Secret"
  value       = module.cores.module_api_keys.flink_api_key
  sensitive   = true
}

output "flink_api_secret" {
  description = "Schema Registry API Secret"
  value       = module.cores.module_api_keys.flink_api_secret
  sensitive   = true
}