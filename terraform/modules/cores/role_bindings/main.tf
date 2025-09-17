resource "confluent_role_binding" "bsnir-pipelines-connectors-service-account-role-binding" {
  principal   = "User:${var.kafka_cluster_sa_id}"
  role_name   = var.role_sa_kafka
  crn_pattern = var.kafka_resource_crn
}

resource "confluent_role_binding" "bsnir-pipelines-schema-registry-service-account-role-binding" {
  principal   = "User:${var.schema_registry_sa_id}"
  role_name   = var.role_sa_schema_registry
  crn_pattern = "${var.schema_registry_resource_name}/subject=*"
}

resource "confluent_role_binding" "bsnir-pipelines-flink-admin-service-account-role-binding" {
  principal   = "User:${var.flink_admin_sa_id}"
  role_name   = var.role_sa_flink_admin
  crn_pattern = var.environment_resource_name
}

resource "confluent_role_binding" "bsnir-pipelines-monitoring-service-account-role-binding" {
  principal   = "User:${var.monitoring_sa_object.id}"
  role_name   = var.role_sa_monitoring
  crn_pattern = var.environment_resource_name
}