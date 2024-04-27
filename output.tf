output "psql_server_id" {
  description = "The Postgres Server Resource ID."
  value       = azurerm_postgresql_server.sonarqube_server.id
}

output "psql_server_fqdn" {
  description = "The Postgres Server FQDN."
  value       = azurerm_postgresql_server.sonarqube_server.fqdn
}

output "psql_user" {
  description = "The Postgres Server username."
  value       = "${local.db_admin_username}@${lower(join("-", [local.region_prefix, local.clean_business_unit, local.clean_application_name, local.environment_tag, "psql"]))}"
}

output "psql_password" {
  description = "The Postgres Server password."
  value       = random_password.psql_admin_password.result
  sensitive   = true
}
