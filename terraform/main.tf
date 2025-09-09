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
# export CONFLUENT_CLOUD_ORGANIZATION_ID
provider "confluent" {}

module "environment" {
  source = "./modules/environment"
}

module "kafka" {
  source = "./modules/kafka"
  environment_id = module.environment.environment_id
  cloud_provider = var.cloud_provider
  region = var.region
}

module "schema_registry" {
  source = "./modules/schema_registry"
  environment_id = module.environment.environment_id
}

module "flink_compute_pool" {
  source = "./modules/flink_compute_pool"
  environment_id = module.environment.environment_id
  cloud_provider = var.cloud_provider
  region = var.region
  max_cfu = 8
}

module "service_accounts" {
  source = "./modules/service_accounts"
}

module "role_bindings" {
  source = "./modules/role_bindings"
  environment_id = module.environment.environment_id
  kafka_cluster_id = module.kafka.kafka_cluster_id
  kafka_resource_crn = module.kafka.kafka_resource_crn
  kafka_cluster_sa_id = module.service_accounts.kafka_cluster_sa_id
  schema_registry_sa_id = module.service_accounts.schema_registry_sa_id
  schema_registry_resource_name = module.schema_registry.schema_registry_resource_name
  role_sa_schema_registry = var.role_sa_schema_registry
  role_sa_kafka = var.role_sa_kafka
}

module "api_keys" {
  source = "./modules/api_keys"
  environment_id = module.environment.environment_id
  kafka_cluster_object = module.kafka.kafka_cluster_object
  kafka_sa_object = module.service_accounts.kafka_sa_object
  schema_registry_sa_object = module.service_accounts.schema_registry_sa_object
  flink_admin_sa_object = module.service_accounts.flink_admin_sa_object
  schema_registry_object = module.schema_registry.schema_registry_object
  flink_region_object = module.flink_compute_pool.flink_region_object
}