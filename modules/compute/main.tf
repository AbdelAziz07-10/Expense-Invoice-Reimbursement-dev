resource "azurerm_user_assigned_identity" "brain" {
  name                = "id-brain-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_user_assigned_identity" "ocr" {
  name                = "id-ocr-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_container_app_environment" "this" {
  name                = "cae-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  log_analytics_workspace_id     = var.log_analytics_workspace_id
  infrastructure_subnet_id       = var.app_subnet_id
  internal_load_balancer_enabled = true

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}

resource "azurerm_container_app" "brain" {
  name                         = "ca-brain-${var.name_suffix}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"
  tags                         = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.brain.id]
  }

  secret {
    name  = "appinsights-connection-string"
    value = var.app_insights_connection_string
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "brain"
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.brain.client_id
      }
      env {
        name  = "SQL_SERVER_FQDN"
        value = var.sql_server_fqdn
      }
      env {
        name  = "SQL_DATABASE_NAME"
        value = var.sql_database_name
      }
      env {
        name  = "SERVICEBUS_NAMESPACE"
        value = "${var.servicebus_namespace_name}.servicebus.windows.net"
      }
      env {
        name  = "STORAGE_ACCOUNT_NAME"
        value = var.storage_account_name
      }
      env {
        name        = "APPLICATIONINSIGHTS_CONNECTION_STRING"
        secret_name = "appinsights-connection-string"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"

    allow_insecure_connections = true

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "ocr" {
  name                         = "ca-ocr-${var.name_suffix}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"
  tags                         = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.ocr.id]
  }

  secret {
    name  = "appinsights-connection-string"
    value = var.app_insights_connection_string
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "ocr"
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.ocr.client_id
      }
      env {
        name  = "SQL_SERVER_FQDN"
        value = var.sql_server_fqdn
      }
      env {
        name  = "SQL_DATABASE_NAME"
        value = var.sql_database_name
      }
      env {
        name  = "SERVICEBUS_NAMESPACE"
        value = "${var.servicebus_namespace_name}.servicebus.windows.net"
      }
      env {
        name  = "STORAGE_ACCOUNT_NAME"
        value = var.storage_account_name
      }
      env {
        name        = "APPLICATIONINSIGHTS_CONNECTION_STRING"
        secret_name = "appinsights-connection-string"
      }
    }
  }
}
