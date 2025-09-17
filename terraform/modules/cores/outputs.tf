output "module_environment" {
  description = "Environment ID"
  value       = module.environment
}

output "module_kafka" {
  description = "Kafka Bootstrap Endpoint"
  value       = module.kafka
}

output "module_schema_registry" {
  description = "Kafka Bootstrap Endpoint"
  value       = module.schema_registry
}

output "module_flink_compute_pool" {
  description = "Flink Compute Pool"
  value       = module.flink_compute_pool
}

output "module_api_keys" {
  description = "API Keys"
  value       = module.api_keys
}

output "module_service_accounts" {
  description = "Service Accounts"
  value       = module.service_accounts
}

output "kafka_bootstrap_endpoint" {
  description = "Kafka Bootstrap Endpoint"
  value       = module.kafka.kafka_bootstrap_endpoint
}

output "schema_registry_rest_endpoint" {
  description = "Connectors API Key"
  value       = module.schema_registry.schema_registry_object.rest_endpoint
}

output "connectors_api_key" {
  description = "Connectors API Key"
  value       = module.api_keys.connectors_api_key
}

output "connectors_api_secret" {
  description = "Connectors API Secret"
  value       = module.api_keys.connectors_api_secret
  sensitive   = true
}

output "schema_registry_api_key" {
  description = "Schema Registry API Key"
  value       = module.api_keys.schema_registry_api_key
}

output "schema_registry_api_secret" {
  description = "Schema Registry API Secret"
  value       = module.api_keys.schema_registry_api_secret
  sensitive   = true
}

output "flink_api_key" {
  description = "Schema Registry API Secret"
  value       = module.api_keys.flink_api_key
  sensitive   = true
}

output "flink_api_secret" {
  description = "Schema Registry API Secret"
  value       = module.api_keys.flink_api_secret
  sensitive   = true
}

output "monitoring_api_key_id" {
  value       = module.api_keys.monitoring_api_key_id
  description = "Monitoring service account API key id (re-export from api_keys module)"
}

output "monitoring_api_key_secret" {
  value       = module.api_keys.monitoring_api_key_secret
  description = "Monitoring service account API key secret (sensitive) (re-export from api_keys module)"
  sensitive   = true
}