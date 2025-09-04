output "environment_id" {
  description = "Confluent Environment ID"
  value       = confluent_environment.bsnir-pipelines-env.id
}

output "kafka_cluster_id" {
  description = "Kafka Cluster ID"
  value       = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.id
}

output "kafka_bootstrap_endpoint" {
  description = "Kafka Bootstrap Endpoint"
  value       = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.bootstrap_endpoint
}

output "schema_registry_id" {
  description = "Schema Registry Cluster ID"
  value       = data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.id
}

output "flink_compute_pool_id" {
  description = "Flink Compute Pool ID"
  value       = confluent_flink_compute_pool.bsnir-pipelines-compute-pool.id
}

output "connectors_service_account_id" {
  description = "Connectors Service Account ID"
  value       = confluent_service_account.bsnir-pipelines-connectors-service-account.id
}

output "schema_registry_service_account_id" {
  description = "Schema Registry Service Account ID"
  value       = confluent_service_account.bsnir-pipelines-schema-registry-service-account.id
}

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