resource "confluent_api_key" "bsnir-pipelines-connectors-service-account-api-key" {
  display_name = "bsnir-pipelines-connectors-service-account-api-key"
  description  = "API keys for connectors Read & Write"
  owner {
    id          = var.kafka_sa_object.id
    api_version = var.kafka_sa_object.api_version
    kind        = var.kafka_sa_object.kind
  }
  managed_resource {
    id          = var.kafka_cluster_object.id
    api_version = var.kafka_cluster_object.api_version
    kind        = var.kafka_cluster_object.kind
    environment {
      id = var.environment_id
    }
  }
}

resource "confluent_api_key" "bsnir-pipelines-schema-registry-service-account-api-key" {
  display_name = "bsnir-pipelines-schema-registry-service-account-api-key"
  description  = "API keys for schema MGMT"
  owner {
    id          = var.schema_registry_sa_object.id
    api_version = var.schema_registry_sa_object.api_version
    kind        = var.schema_registry_sa_object.kind
  }

  managed_resource {
    id          = var.schema_registry_object.id
    api_version = var.schema_registry_object.api_version
    kind        = var.schema_registry_object.kind
    environment {
      id = var.environment_id
    }
  }
}

resource "confluent_api_key" "bsnir-pipelines-flink-service-account-api-key" {
  display_name = "bsnir-pipelines-flink-service-account-api-key"
  description  = "Flink API Key that is owned by 'env-manager' service account"
  owner {
    id          = var.flink_admin_sa_object.id
    api_version = var.flink_admin_sa_object.api_version
    kind        = var.flink_admin_sa_object.kind
  }

  managed_resource {
    id          = var.flink_region_object.id
    api_version = var.flink_region_object.api_version
    kind        = var.flink_region_object.kind

    environment {
      id = var.environment_id
    }
  }
}

resource "confluent_api_key" "bsnir-pipelines-monitoring-service-account-api-key" {
  display_name = "bsnir-pipelines-monitoring-service-account-api-key"
  description  = "API key for monitoring service account"

  owner {
    id          = var.monitoring_sa_object.id
    api_version = var.monitoring_sa_object.api_version
    kind        = var.monitoring_sa_object.kind
  }
}