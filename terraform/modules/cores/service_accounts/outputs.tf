output kafka_cluster_sa_id {
  description = "Kafka Cluster Service Account ID"
  value = confluent_service_account.bsnir-pipelines-connectors-service-account.id
}
output schema_registry_sa_id {
  description = "Schema Registry Service Account ID"
  value = confluent_service_account.bsnir-pipelines-schema-registry-service-account.id
}

output kafka_sa_object {
  description = "kafka_sa_object"
  value = {
    id          = confluent_service_account.bsnir-pipelines-connectors-service-account.id
    api_version = confluent_service_account.bsnir-pipelines-connectors-service-account.api_version
    kind        = confluent_service_account.bsnir-pipelines-connectors-service-account.kind
  }
}

output schema_registry_sa_object {
  description = "schema_registry_sa_object"
  value = {
    id          = confluent_service_account.bsnir-pipelines-schema-registry-service-account.id
    api_version = confluent_service_account.bsnir-pipelines-schema-registry-service-account.api_version
    kind        = confluent_service_account.bsnir-pipelines-schema-registry-service-account.kind
  }
}

output flink_admin_sa_object {
  description = "flink_admin_sa_object"
  value = {
    id          = confluent_service_account.bsnir-pipelines-flink-admin-service-account.id
    api_version = confluent_service_account.bsnir-pipelines-flink-admin-service-account.api_version
    kind        = confluent_service_account.bsnir-pipelines-flink-admin-service-account.kind
  }
}

output "monitoring_service_account_id" {
  value       = confluent_service_account.monitoring.id
  description = "ID of the monitoring service account"
}

output "monitoring_sa_object" {
  value = {
    id          = confluent_service_account.monitoring.id
    api_version = confluent_service_account.monitoring.api_version
    kind        = confluent_service_account.monitoring.kind
  }
  description = "Object for monitoring service account (id, api_version, kind)"
}