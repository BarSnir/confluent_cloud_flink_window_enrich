resource "confluent_flink_statement" "order-alter-append-changelog-statement" {
  statement  = trimspace(file("${path.module}/queries/orders-append-changelog.sql"))
  statement_name = "orders-append-changelog"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-customers-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-customers-dimension.sql"))
  statement_name = "create-customers-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-customers-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-customers.sql"))
  statement_name = "insert-customers"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-customers-dimension-statement
  ]
}

resource "confluent_flink_statement" "create-images-dimensions-statement" {
  statement  = trimspace(file("${path.module}/queries/create-images-dimensions.sql"))
  statement_name = "create-images-dimensions"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-images-aggregate-dimensions-statement" {
  statement  = trimspace(file("${path.module}/queries/create-images-aggregate-dimensions.sql"))
  statement_name = "create-images-aggregate-dimensions"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-improving-parts-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-improving-parts-dimension.sql"))
  statement_name = "create-improving-parts-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-improving-parts-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-improving-parts.sql"))
  statement_name = "insert-improving-parts"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-improving-parts-dimension-statement
  ]
}


resource "confluent_flink_statement" "create-market-info-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-market-info-dimension.sql"))
  statement_name = "create-market-info-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}
 
resource "confluent_flink_statement" "insert-market-info-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-market-info.sql"))
  statement_name = "insert-market-info"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-market-info-dimension-statement
  ]
}

resource "confluent_flink_statement" "create-media-type-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-media-type-dimension.sql"))
  statement_name = "create-media-type-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-media-type-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-media-type.sql"))
  statement_name = "insert-media-type"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-media-type-dimension-statement
  ]
}

resource "confluent_flink_statement" "create-vehicle-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-vehicle-dimension.sql"))
  statement_name = "create-vehicle-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-vehicle-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-vehicle-dimension.sql"))
  statement_name = "insert-vehicle-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-vehicle-dimension-statement
  ]
}


resource "confluent_flink_statement" "create-vehicle-enriched-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-vehicle-enriched-dimension.sql"))
  statement_name = "create-vehicle-enriched-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-images-aggregate-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-images-aggregate.sql"))
  statement_name = "insert-images-aggregate"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-images-aggregate-dimensions-statement,
    confluent_flink_statement.create-images-dimensions-statement
  ]
}

resource "confluent_flink_statement" "insert-vehicle-enriched-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-vehicle-enriched.sql"))
  statement_name = "insert-vehicle-enriched"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-vehicle-enriched-dimension-statement,
    confluent_flink_statement.create-vehicle-dimension-statement,
    confluent_flink_statement.create-images-aggregate-dimensions-statement,
    confluent_flink_statement.create-improving-parts-dimension-statement,
    confluent_flink_statement.create-market-info-dimension-statement,
    confluent_flink_statement.create-media-type-dimension-statement,
    confluent_flink_statement.insert-images-aggregate-statement
  ]
}

resource "confluent_flink_statement" "create-orders-vehicle-enriched-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-orders-vehicle-enriched-dimension.sql"))
  statement_name = "create-orders-vehicle-enriched-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-orders-vehicle-enriched-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-orders-vehicle-enriched.sql"))
  statement_name = "insert-orders-vehicle-enriched"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-orders-vehicle-enriched-dimension-statement,
    confluent_flink_statement.create-vehicle-enriched-dimension-statement,
    confluent_flink_statement.insert-vehicle-enriched-statement
  ]
}

resource "confluent_flink_statement" "create-customer-agg-5m-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-customer-agg-5m-dimension.sql"))
  statement_name = "create-customer-agg-5m-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-customer-agg-5m-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-customer-agg-5m.sql"))
  statement_name = "insert-customer-agg-5m"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-customer-agg-5m-dimension-statement,
    confluent_flink_statement.order-alter-append-changelog-statement
  ]
}

resource "confluent_flink_statement" "create-orders-vehicle-enriched-windowed-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-orders-vehicle-enriched-windowed-dimension.sql"))
  statement_name = "create-orders-vehicle-enriched-windowed-dimension"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-orders-vehicle-enriched-windowed-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-orders-vehicle-enriched-windowed.sql"))
  statement_name = "insert-orders-vehicle-enriched-windowed"
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
  depends_on = [
    confluent_flink_statement.create-orders-vehicle-enriched-windowed-dimension-statement,
    confluent_flink_statement.insert-orders-vehicle-enriched-statement,
    confluent_flink_statement.insert-customer-agg-5m-statement
  ]
}