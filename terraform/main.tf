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

module "cores" {
  source  = "./modules/cores"
  region     = var.region
  cloud_provider = var.cloud_provider
  role_sa_kafka = var.role_sa_kafka
  role_sa_schema_registry = var.role_sa_schema_registry
  role_sa_flink_admin = var.role_sa_flink_admin
}

module "sql" {
  source  = "./modules/sql"
  flink_rest_endpoint = module.cores.module_flink_compute_pool.flink_region_object.rest_endpoint
  environment_id = module.cores.module_environment.environment_id
  environment_display_name = module.cores.module_environment.environment_display_name
  kafka_cluster_display_name = module.cores.module_kafka.kafka_cluster_object.display_name
  flink_admin_sa_object = module.cores.module_service_accounts.flink_admin_sa_object
  flink_compute_pool_id = module.cores.module_flink_compute_pool.flink_region_object.id
  flink_api_key = module.cores.module_api_keys.flink_api_key
  flink_api_secret = module.cores.module_api_keys.flink_api_secret
}