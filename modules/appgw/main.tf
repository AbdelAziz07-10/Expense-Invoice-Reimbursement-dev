locals {
  frontend_ip_name   = "feip-public"
  frontend_port_name = "feport-http"
  listener_name      = "listener-http"
  gateway_ip_name    = "gwip"
  pool_brain         = "pool-brain"
  settings_brain     = "bes-brain"
  probe_brain        = "probe-brain"
  rule_name          = "rule-main"
}

resource "azurerm_public_ip" "appgw" {
  name                = "pip-agw-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_web_application_firewall_policy" "this" {
  name                = "waf-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  policy_settings {
    enabled                     = true
    mode                        = var.waf_mode
    request_body_check          = true
    max_request_body_size_in_kb = 128
    file_upload_limit_in_mb     = 100
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "this" {
  name                = "agw-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewall_policy_id  = azurerm_web_application_firewall_policy.this.id
  tags                = var.tags

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = var.autoscale_min_capacity
    max_capacity = var.autoscale_max_capacity
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_name
    subnet_id = var.appgw_subnet_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  backend_address_pool {
    name         = local.pool_brain
    ip_addresses = [var.brain_backend_ip]
  }

  probe {
    name                = local.probe_brain
    protocol            = "Http"
    host                = var.brain_backend_fqdn
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

    match {
      status_code = ["200-499"]
    }
  }

  backend_http_settings {
    name                  = local.settings_brain
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    host_name             = var.brain_backend_fqdn
    probe_name            = local.probe_brain
  }

  request_routing_rule {
    name                       = local.rule_name
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.pool_brain
    backend_http_settings_name = local.settings_brain
  }
}

resource "azurerm_monitor_diagnostic_setting" "appgw" {
  name                       = "diag-appgw"
  target_resource_id         = azurerm_application_gateway.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
