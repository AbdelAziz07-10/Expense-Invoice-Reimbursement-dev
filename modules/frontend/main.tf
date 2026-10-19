resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_service_plan" "frontend" {
  name                = "asp-web-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}

resource "azurerm_linux_web_app" "frontend" {
  name                = "app-web-${var.name_suffix}-${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.frontend.id
  https_only          = true
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on           = var.site_config.always_on
    minimum_tls_version = var.site_config.minimum_tls_version
    ftps_state          = var.site_config.ftps_state
    http2_enabled       = var.site_config.http2_enabled

    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
  }
}

resource "azurerm_monitor_diagnostic_setting" "frontend" {
  name                       = "diag-frontend"
  target_resource_id         = azurerm_linux_web_app.frontend.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
