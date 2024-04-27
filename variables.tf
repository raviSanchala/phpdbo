variable "postgres_server_sku_name" {
  description = "PostgreSQL server SKU size."
  type        = string
}

variable "db_version" {
  description = "PostgreSQL server major version number."
  type        = number
  default     = 11
}

variable "db_storage" {
  description = "PostgreSQL server storage size."
  type        = number
}

variable "backup_retention_days" {
  description = "Number of days to retain data for rollback on the PostgreSQL server"
  type        = number
}
