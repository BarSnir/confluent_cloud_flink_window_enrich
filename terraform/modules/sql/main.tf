resource "confluent_flink_statement" "order-alter-append-changelog-statement" {
  statement  = trimspace(file("${path.module}/queries/orders-append-changelog.sql"))
  properties = {
    "sql.current-catalog"  = "bsnir_pipelines_env"
    "sql.current-database" = "bsnir_tf_standard_cluster"
  }
}

resource "confluent_flink_statement" "create-vehicles-dimensions-statement" {
  statement  = trimspace(file("${path.module}/queries/create-vehicles-dimensions.sql"))
  properties = {
    "sql.current-catalog"  = "bsnir_pipelines_env"
    "sql.current-database" = "bsnir_tf_standard_cluster"
  }
  depends_on = [
    confluent_flink_statement.order-alter-append-changelog-statement
  ]
}