resource "confluent_flink_statement" "order-alter-append-changelog-statement" {
  statement  = trimspace(file("${path.module}/queries/orders-append-changelog.sql"))
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-customers-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-customers-dimension.sql"))
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-images-dimensions-statement" {
  statement  = trimspace(file("${path.module}/queries/create-images-dimensions.sql"))
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-images-aggregate-dimensions-statement" {
  statement  = trimspace(file("${path.module}/queries/create-images-aggregate-dimensions.sql"))
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-improving-parts-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-improving-parts-dimension.sql"))
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-market-info-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-market-info-dimension.sql"))
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-media-type-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-media-type-dimension.sql"))
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "create-vehicle-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/create-vehicle-dimension.sql"))
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-vehicle-dimension-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-vehicle-dimension.sql"))
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
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-images-aggregate-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-images-aggregate.sql"))
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
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-orders-vehicle-enriched-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-orders-vehicle-enriched.sql"))
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
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-customer-agg-5m-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-customer-agg-5m.sql"))
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
  properties = {
    "sql.current-catalog"  = var.catalog
    "sql.current-database" = var.database
  }
}

resource "confluent_flink_statement" "insert-orders-vehicle-enriched-windowed-statement" {
  statement  = trimspace(file("${path.module}/queries/insert-orders-vehicle-enriched-windowed.sql"))
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