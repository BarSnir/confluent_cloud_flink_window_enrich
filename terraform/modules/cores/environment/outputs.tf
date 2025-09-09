output environment_id {
  description = "Confluent Environment ID"
  value = confluent_environment.bsnir-pipelines-env.id
}

output environment_display_name {
  description = "Confluent Environment Display Name"
  value = confluent_environment.bsnir-pipelines-env.display_name
}

output environment_resource_name {
  description = "Confluent Environment Display Name"
  value = confluent_environment.bsnir-pipelines-env.resource_name
}