locals {
  sql_admin_password = var.sql_admin_password != null ? var.sql_admin_password : random_password.sql[0].result
  use_premium        = var.servicebus_sku == "Premium"
}

resource "random_string" "storage_suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_storage_account" "this" {
  name                = substr("st${replace(var.project, "-", "")}${var.environment}${random_string.storage_suffix.result}", 0, 24)
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  account_tier                    = "Standard"
  account_replication_type        = var.storage_replication_type
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = var.storage_public_network_access_enabled
}

resource "azurerm_storage_container" "raw" {
  name                  = "raw-uploads"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "clean" {
  name                  = "clean-files"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "random_password" "sql" {
  count = var.sql_admin_password == null ? 1 : 0

  length           = 28
  special          = true
  override_special = "!#%*-_=+"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "azurerm_mssql_server" "this" {
  name                = "sql-${var.name_suffix}-${random_string.storage_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  version                       = "12.0"
  administrator_login           = var.sql_admin_login
  administrator_login_password  = local.sql_admin_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = !var.enable_private_endpoints
}

resource "azurerm_mssql_database" "this" {
  name        = "sqldb-${var.name_suffix}"
  server_id   = azurerm_mssql_server.this.id
  sku_name    = var.sql_database_sku
  max_size_gb = var.sql_max_size_gb
  tags        = var.tags
}

resource "azurerm_servicebus_namespace" "this" {
  name                = "sb-${var.name_suffix}-${random_string.storage_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku                           = var.servicebus_sku
  capacity                      = local.use_premium ? 1 : 0
  premium_messaging_partitions  = local.use_premium ? 1 : 0
  local_auth_enabled            = false
  public_network_access_enabled = !var.enable_servicebus_private_endpoint

  lifecycle {
    precondition {
      condition     = !var.enable_servicebus_private_endpoint || local.use_premium
      error_message = "A Service Bus private endpoint requires servicebus_sku = \"Premium\"."
    }
  }
}

resource "azurerm_servicebus_queue" "this" {
  for_each = var.servicebus_queues

  name                                 = each.value
  namespace_id                         = azurerm_servicebus_namespace.this.id
  max_delivery_count                   = 10
  lock_duration                        = "PT1M"
  dead_lettering_on_message_expiration = true
}

resource "azurerm_private_endpoint" "sql" {
  count = var.enable_private_endpoints ? 1 : 0

  name                = "pep-sql-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.data_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-sql"
    private_connection_resource_id = azurerm_mssql_server.this.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["sql"]]
  }
}

resource "azurerm_private_endpoint" "blob" {
  count = var.enable_private_endpoints ? 1 : 0

  name                = "pep-blob-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.data_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-blob"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["blob"]]
  }
}

resource "azurerm_private_endpoint" "servicebus" {
  count = var.enable_servicebus_private_endpoint ? 1 : 0

  name                = "pep-sb-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.data_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-servicebus"
    private_connection_resource_id = azurerm_servicebus_namespace.this.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["servicebus"]]
  }
}

resource "azurerm_monitor_diagnostic_setting" "sql_database" {
  name                       = "diag-sqldb"
  target_resource_id         = azurerm_mssql_database.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "blob" {
  name                       = "diag-blob"
  target_resource_id         = "${azurerm_storage_account.this.id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "servicebus" {
  name                       = "diag-servicebus"
  target_resource_id         = azurerm_servicebus_namespace.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
