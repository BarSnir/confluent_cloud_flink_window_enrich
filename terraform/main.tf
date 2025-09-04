#----------------------------------------------------------------
# Init
#----------------------------------------------------------------
terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.38.0"          
    }
  }
}
# export CONFLUENT_CLOUD_API_KEY
# export CONFLUENT_CLOUD_API_SECRET
provider "confluent" {}

#----------------------------------------------------------------
# Environment
#----------------------------------------------------------------

resource "confluent_environment" "bsnir-pipelines-env" {
  display_name = "bsnir_pipelines_env"
}

#----------------------------------------------------------------
# Cluster
#----------------------------------------------------------------

resource "confluent_kafka_cluster" "bsnir-pipelines-standard-cluster" {
  display_name = "bsnir_tf_standard_cluster"
  availability = "SINGLE_ZONE"
  cloud = var.cloud
  region = var.region
  standard {}
  environment {
    id = confluent_environment.bsnir-pipelines-env.id
  }
}

#----------------------------------------------------------------
# Schema Registry
#----------------------------------------------------------------

data "confluent_schema_registry_cluster" "bsnir-pipelines-schema-registry" {
  environment {
    id = confluent_environment.bsnir-pipelines-env.id
  }
}

#----------------------------------------------------------------
# Compute Pool
#----------------------------------------------------------------

data "confluent_flink_region" "bsnir-pipelines-compute-pool-data" {
  cloud   = "AWS"
  region  = "eu-west-1"
}


resource "confluent_flink_compute_pool" "bsnir-pipelines-compute-pool" {
  display_name     = "bsnir-pipelines-compute-pool"
  cloud            = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.cloud
  region           = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.region
  max_cfu          = 5
  environment {
    id = confluent_environment.bsnir-pipelines-env.id
  }
}

#----------------------------------------------------------------
# Service Account                                                          
#----------------------------------------------------------------

resource "confluent_service_account" "bsnir-pipelines-connectors-service-account" {
  display_name = "bsnir-pipelines-connectors-service-account"
  description  = "Service account for application management"
}

resource "confluent_service_account" "bsnir-pipelines-schema-registry-service-account" {
  display_name = "bsnir-pipelines-schema-registry-service-account"
  description  = var.sr_api_key_description
  depends_on = [
    data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry
  ]
}

resource "confluent_service_account" "bsnir-pipelines-flink-admin-service-account" {
  display_name = "bsnir-pipelines-flink-admin-service-account"
  description  = var.flink_admin_service_account_description
  depends_on = [
    resource.confluent_flink_compute_pool.bsnir-pipelines-compute-pool
  ]
}




#----------------------------------------------------------------
#  Role bindings                                                        
#----------------------------------------------------------------

resource "confluent_role_binding" "bsnir-pipelines-connectors-service-account-role-binding" {
  principal   = "User:${confluent_service_account.bsnir-pipelines-connectors-service-account.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.rbac_crn
}

resource "confluent_role_binding" "bsnir-pipelines-schema-registry-service-account-role-binding" {
  principal   = "User:${confluent_service_account.bsnir-pipelines-schema-registry-service-account.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.resource_name}/subject=*"
  depends_on = [
    confluent_service_account.bsnir-pipelines-schema-registry-service-account,
    data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry
  ]
}

#----------------------------------------------------------------
# API Keys                                                           
#----------------------------------------------------------------
resource "confluent_api_key" "bsnir-pipelines-connectors-service-account-api-key" {
  display_name = "bsnir-pipelines-connectors-service-account-api-key"
  description  = "API keys for connectors Read & Write"
  owner {
    id          = confluent_service_account.bsnir-pipelines-connectors-service-account.id
    api_version = confluent_service_account.bsnir-pipelines-connectors-service-account.api_version
    kind        = confluent_service_account.bsnir-pipelines-connectors-service-account.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.id
    api_version = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.api_version
    kind        = confluent_kafka_cluster.bsnir-pipelines-standard-cluster.kind

    environment {
      id = confluent_environment.bsnir-pipelines-env.id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_api_key" "bsnir-pipelines-schema-registry-service-account-api-key" {
  display_name = "bsnir-pipelines-schema-registry-service-account-api-key"
  description  = "API keys for schema MGMT"
  owner {
    id          = confluent_service_account.bsnir-pipelines-schema-registry-service-account.id
    api_version = confluent_service_account.bsnir-pipelines-schema-registry-service-account.api_version
    kind        = confluent_service_account.bsnir-pipelines-schema-registry-service-account.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.id
    api_version = data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.api_version
    kind        = data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.kind
    environment {
      id = confluent_environment.bsnir-pipelines-env.id
    }
  }
  depends_on = [
    confluent_service_account.bsnir-pipelines-schema-registry-service-account,
    data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry
  ]
}


resource "confluent_api_key" "bsnir-pipelines-flink-service-account-api-key" {
  display_name = "bsnir-pipelines-flink-service-account-api-key"
  description  = "Flink API Key that is owned by 'env-manager' service account"
  owner {
    id          = confluent_service_account.bsnir-pipelines-flink-admin-service-account.id
    api_version = confluent_service_account.bsnir-pipelines-flink-admin-service-account.api_version
    kind        = confluent_service_account.bsnir-pipelines-flink-admin-service-account.kind
  }

  managed_resource {
    id          = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.id
    api_version = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.api_version
    kind        = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.kind

    environment {
      id = confluent_environment.bsnir-pipelines-env.id
    }
  }
}

