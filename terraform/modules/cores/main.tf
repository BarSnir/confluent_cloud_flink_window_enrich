module "environment" {
  source = "./environment"
}

module "kafka" {
  source = "./kafka"
  environment_id = module.environment.environment_id
  cloud_provider = var.cloud_provider
  region = var.region
  depends_on = [module.environment]
}

module "schema_registry" {
  source = "./schema_registry"
  environment_id = module.environment.environment_id
  depends_on = [module.environment]
}

module "flink_compute_pool" {
  source = "./flink_compute_pool"
  environment_id = module.environment.environment_id
  cloud_provider = var.cloud_provider
  region = var.region
  depends_on = [module.environment, module.schema_registry]
}

module "service_accounts" {
  source = "./service_accounts"
}

module "role_bindings" {
  source = "./role_bindings"
  environment_id = module.environment.environment_id
  environment_resource_name = module.environment.environment_resource_name
  kafka_cluster_id = module.kafka.kafka_cluster_id
  kafka_resource_crn = module.kafka.kafka_resource_crn
  kafka_cluster_sa_id = module.service_accounts.kafka_cluster_sa_id
  schema_registry_sa_id = module.service_accounts.schema_registry_sa_id
  schema_registry_resource_name = module.schema_registry.schema_registry_resource_name
  role_sa_schema_registry = var.role_sa_schema_registry
  role_sa_kafka = var.role_sa_kafka
  role_sa_flink_admin = var.role_sa_flink_admin
  flink_admin_sa_id = module.service_accounts.flink_admin_sa_object.id
  depends_on = [module.environment, module.kafka, module.schema_registry, module.service_accounts]
}

module "api_keys" {
  source = "./api_keys"
  environment_id = module.environment.environment_id
  kafka_cluster_object = module.kafka.kafka_cluster_object
  kafka_sa_object = module.service_accounts.kafka_sa_object
  schema_registry_sa_object = module.service_accounts.schema_registry_sa_object
  flink_admin_sa_object = module.service_accounts.flink_admin_sa_object
  schema_registry_object = module.schema_registry.schema_registry_object
  flink_region_object = module.flink_compute_pool.flink_region_object
  depends_on = [module.environment, module.kafka, module.schema_registry, module.service_accounts, module.flink_compute_pool, module.role_bindings]
}