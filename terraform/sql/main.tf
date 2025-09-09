# Read the root module state (local file in parent folder)
data "terraform_remote_state" "root" {
  backend = "local"
  config = {
    path = "${path.root}/../terraform.tfstate"
  }
}

# Use values from the root state
resource "confluent_flink_statement" "prepare_orders_table" {
  environment  { id = data.terraform_remote_state.root.outputs.environment_id }
  compute_pool { id = data.terraform_remote_state.root.outputs.flink_compute_pool_id }
  principal    { id = data.terraform_remote_state.root.outputs.flink_service_account }

  statement = file("${path.module}/jobs/prepare_orders.sql")

  properties = {
    "sql.current-catalog"  = data.terraform_remote_state.root.outputs.environment_name
    "sql.current-database" = data.terraform_remote_state.root.outputs.kafka_cluster_name
  }

  rest_endpoint = data.terraform_remote_state.root.outputs.flink_rest_endpoint

  credentials {
    key    = data.terraform_remote_state.root.outputs.flink_api_key
    secret = data.terraform_remote_state.root.outputs.flink_api_secret
  }

  lifecycle {
    prevent_destroy = false
  }
}