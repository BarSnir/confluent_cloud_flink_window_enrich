resource "confluent_service_account" "bsnir-pipelines-connectors-service-account" {
  display_name = "bsnir-pipelines-connectors-service-account"
  description  = ""
}

resource "confluent_service_account" "bsnir-pipelines-schema-registry-service-account" {
  display_name = "bsnir-pipelines-schema-registry-service-account"
  description  = ""
}

resource "confluent_service_account" "bsnir-pipelines-flink-admin-service-account" {
  display_name = "bsnir-pipelines-flink-admin-service-account"
  description  = ""
}