output flink_region_object {
  description = "Flink Region Object"
  value = {
    id          = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.id
    api_version = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.api_version
    kind        = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.kind
    rest_endpoint = data.confluent_flink_region.bsnir-pipelines-compute-pool-data.rest_endpoint
  }
}