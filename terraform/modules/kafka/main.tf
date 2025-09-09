resource "confluent_kafka_cluster" "bsnir-pipelines-standard-cluster" {
  display_name = "bsnir_tf_standard_cluster"
  availability = "SINGLE_ZONE"
  cloud = var.cloud_provider
  region = var.region
  standard {}
  environment {
    id = var.environment_id
  }
}