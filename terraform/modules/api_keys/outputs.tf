output "connectors_api_key" {
  description = "Connectors API Key"
  value       = confluent_api_key.bsnir-pipelines-connectors-service-account-api-key.id
}

output "connectors_api_secret" {
  description = "Connectors API Secret"
  value       = confluent_api_key.bsnir-pipelines-connectors-service-account-api-key.secret
  sensitive   = true
}

output "schema_registry_api_key" {
  description = "Schema Registry API Key"
  value       = confluent_api_key.bsnir-pipelines-schema-registry-service-account-api-key.id
}

output "schema_registry_api_secret" {
  description = "Schema Registry API Secret"
  value       = confluent_api_key.bsnir-pipelines-schema-registry-service-account-api-key.secret
  sensitive   = true
}

output "flink_api_key" {
  description = "Schema Registry API Secret"
  value       = confluent_api_key.bsnir-pipelines-flink-service-account-api-key.id
  sensitive   = true
}

output "flink_api_secret" {
  description = "Schema Registry API Secret"
  value       = confluent_api_key.bsnir-pipelines-flink-service-account-api-key.secret
  sensitive   = true
}