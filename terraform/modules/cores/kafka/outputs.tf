output "kafka_cluster_id" {
  description = "Kafka Cluster ID"
  value       = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.id
}

output "kafka_bootstrap_endpoint" {
  description = "Kafka Bootstrap Endpoint"
  value       = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.bootstrap_endpoint
}

output "kafka_resource_crn" {
  description = "Kafka Cluster Resource CRN"
  value       = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.rbac_crn
}

output "kafka_cluster_object" {
  description = "Kafka Cluster Object"
  value = {
    id   = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.id
    api_version = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.api_version
    kind   = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.kind
  }
}