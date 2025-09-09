data "confluent_schema_registry_cluster" "bsnir-pipelines-schema-registry" {
  environment {
    id = var.environment_id
  }
  depends_on = [var.environment_id]
}