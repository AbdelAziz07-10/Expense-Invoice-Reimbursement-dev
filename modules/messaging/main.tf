resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_signalr_service" "this" {
  name                = "sigr-${var.name_suffix}-${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  service_mode = "Default"

  sku {
    name     = var.signalr_sku_name
    capacity = var.signalr_capacity
  }
}

resource "azurerm_email_communication_service" "this" {
  name                = "acse-${var.name_suffix}-${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  data_location       = var.email_data_location
  tags                = var.tags
}

resource "azurerm_email_communication_service_domain" "managed" {
  name              = "AzureManagedDomain"
  email_service_id  = azurerm_email_communication_service.this.id
  domain_management = "AzureManaged"
  tags              = var.tags
}

resource "azurerm_communication_service" "this" {
  name                = "acs-${var.name_suffix}-${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  data_location       = var.email_data_location
  tags                = var.tags
}

resource "azurerm_communication_service_email_domain_association" "this" {
  communication_service_id = azurerm_communication_service.this.id
  email_service_domain_id  = azurerm_email_communication_service_domain.managed.id
}

resource "azurerm_user_assigned_identity" "function" {
  name                = "id-func-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_storage_account" "function" {
  name                            = substr("stfn${var.environment}${random_string.suffix.result}${replace(var.name_suffix, "-", "")}", 0, 24)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tags                            = var.tags
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}

resource "azurerm_service_plan" "function" {
  name                = "asp-func-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  os_type             = "Linux"
  sku_name            = var.function_plan_sku
}

resource "azurerm_linux_function_app" "this" {
  name                = "func-${var.name_suffix}-${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  service_plan_id            = azurerm_service_plan.function.id
  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key
  https_only                 = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.function.id]
  }

  site_config {
    application_insights_connection_string = var.app_insights_connection_string

    application_stack {
      node_version = "20"
    }
  }

  app_settings = {
    "ServiceBusConnection__fullyQualifiedNamespace" = "${var.servicebus_namespace_name}.servicebus.windows.net"
    "ServiceBusConnection__credential"              = "managedidentity"
    "ServiceBusConnection__clientId"                = azurerm_user_assigned_identity.function.client_id
    "NOTIFICATIONS_QUEUE_NAME"                      = var.notifications_queue_name
    "EMAIL_SENDER_DOMAIN"                           = azurerm_email_communication_service_domain.managed.mail_from_sender_domain
    "COMMUNICATION_SERVICE_NAME"                    = azurerm_communication_service.this.name
  }
}

resource "azurerm_eventgrid_system_topic" "storage" {
  count = var.enable_eventgrid_topic ? 1 : 0

  name                = "evgt-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  source_resource_id  = var.storage_account_id
  topic_type          = "Microsoft.Storage.StorageAccounts"
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_eventgrid_system_topic_event_subscription" "scan_results" {
  count = var.enable_eventgrid_topic && var.enable_eventgrid_subscription ? 1 : 0

  name                = "evgs-scan-results-${var.name_suffix}"
  system_topic        = azurerm_eventgrid_system_topic.storage[0].name
  resource_group_name = var.resource_group_name

  included_event_types = var.eventgrid_event_types

  subject_filter {
    subject_begins_with = "/blobServices/default/containers/${var.raw_container_name}/"
  }

  service_bus_queue_endpoint_id = var.scan_results_queue_id

  delivery_identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_monitor_diagnostic_setting" "signalr" {
  name                       = "diag-signalr"
  target_resource_id         = azurerm_signalr_service.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "function" {
  name                       = "diag-function"
  target_resource_id         = azurerm_linux_function_app.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
