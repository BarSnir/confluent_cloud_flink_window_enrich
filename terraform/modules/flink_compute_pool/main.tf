data "confluent_flink_region" "bsnir-pipelines-compute-pool-data" {
  cloud   = var.cloud_provider
  region  = var.region
}

resource "confluent_flink_compute_pool" "bsnir-pipelines-compute-pool" {
  display_name     = "bsnir-pipelines-compute-pool"
  cloud            = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.cloud
  region           = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.region
  max_cfu          = var.max_cfu
  environment { 
    id = var.environment_id 
  }
}