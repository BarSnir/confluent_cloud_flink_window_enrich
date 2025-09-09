output schema_registry_resource_name {
  description = "Schema Registry Resource Name"
  value = data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.resource_name
}

output schema_registry_object {
  description = "Schema Registry Object"
  value = {
      id          = data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.id
      api_version = data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.api_version
      kind        = data.confluent_schema_registry_cluster.bsnir-pipelines-schema-registry.kind
  }  
}