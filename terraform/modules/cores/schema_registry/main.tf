data "confluent_schema_registry_cluster" "bsnir-pipelines-schema-registry" {
  environment {
    id = var.environment_id
  }
}