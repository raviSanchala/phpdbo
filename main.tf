locals {
  db_admin_username = "SonarqubeAdmin"
  postgres_db_name  = "sonarqube"
}

# Postgres Password
resource "random_password" "psql_admin_password" {
  length           = 32
  special          = true
  override_special = "@-_+?"
}

resource "azurerm_postgresql_server" "sonarqube_server" {
  name                = lower(join("-", [local.region_prefix, local.clean_business_unit, local.clean_application_name, local.environment_tag, "psql"]))
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = local.region_name

  sku_name                     = var.postgres_server_sku_name
  version                      = var.db_version
  storage_mb                   = var.db_storage
  backup_retention_days        = var.backup_retention_days
  administrator_login          = local.db_admin_username
  administrator_login_password = random_password.psql_admin_password.result
  tags                         = merge(local.tags, { "ResourceFunction" : "Compute", "ResourceRegion" : local.region_name })

  geo_redundant_backup_enabled     = true
  auto_grow_enabled                = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_firewall_rule" "azurefirewall" {
  resource_group_name = data.azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.sonarqube_server.name
  name                = "azure-resources"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_database" "sonarqube_database" {
  name                = local.postgres_db_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.sonarqube_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
  depends_on = [
    azurerm_postgresql_server.sonarqube_server,
  ]

  lifecycle {
    prevent_destroy = true
  }
}
