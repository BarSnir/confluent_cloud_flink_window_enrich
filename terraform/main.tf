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

module "cores" {
  source  = "./modules/cores"
  region     = var.region
  cloud_provider = var.cloud_provider
  role_sa_kafka = var.role_sa_kafka
  role_sa_schema_registry = var.role_sa_schema_registry
}

module "sql" {
  source  = "./modules/sql"
}

