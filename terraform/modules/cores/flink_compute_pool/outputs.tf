output flink_region_object {
  description = "Flink Region Object"
  value = {
    id          = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.id
    api_version = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.api_version
    kind        = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.kind
    rest_endpoint = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.rest_endpoint
  }
}

output flink_compute_pool {
  description = "Flink Compute Pool Object"
  value = {
    id = confluent_flink_compute_pool.bsnir-pipelines-compute-pool.id
  }
}