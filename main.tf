locals {
  name_suffix = "${var.project}-${var.environment}"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_suffix}"
  location = var.location
  tags     = var.tags
}

module "networking" {
  source = "./modules/networking"

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  vnet_address_space = var.vnet_address_space
  appgw_subnet_cidr  = var.appgw_subnet_cidr
  app_subnet_cidr    = var.app_subnet_cidr
  data_subnet_cidr   = var.data_subnet_cidr

  enable_nat_gateway   = var.enable_nat_gateway
  create_nat_public_ip = var.create_nat_public_ip
}

module "private_dns" {
  source = "./modules/private_dns"

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  vnet_id             = module.networking.vnet_id
  tags                = var.tags
}

module "monitoring" {
  source = "./modules/monitoring"

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  retention_in_days = var.log_retention_days
}

module "data" {
  source = "./modules/data"

  name_suffix         = local.name_suffix
  project             = var.project
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  data_subnet_id                     = module.networking.subnet_ids["data"]
  private_dns_zone_ids               = module.private_dns.zone_ids
  enable_private_endpoints           = var.enable_private_endpoints
  enable_servicebus_private_endpoint = var.enable_servicebus_private_endpoint

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  storage_public_network_access_enabled = var.storage_public_network_access_enabled
  sql_admin_login                       = var.sql_admin_login
  sql_admin_password                    = var.sql_admin_password
  sql_database_sku                      = var.sql_database_sku
  servicebus_sku                        = var.servicebus_sku
}

module "compute" {
  source = "./modules/compute"

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  app_subnet_id                  = module.networking.subnet_ids["app"]
  log_analytics_workspace_id     = module.monitoring.log_analytics_workspace_id
  app_insights_connection_string = module.monitoring.application_insights_connection_string

  sql_server_fqdn           = module.data.sql_server_fqdn
  sql_database_name         = module.data.sql_database_name
  servicebus_namespace_name = module.data.servicebus_namespace_name
  storage_account_name      = module.data.storage_account_name

  container_image = var.container_image
}

module "appgw" {
  source = "./modules/appgw"

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  appgw_subnet_id            = module.networking.subnet_ids["appgw"]
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  brain_backend_ip   = module.compute.environment_static_ip
  brain_backend_fqdn = module.compute.brain_fqdn

  waf_mode = var.waf_mode
}

module "frontend" {
  source = "./modules/frontend"

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  log_analytics_workspace_id     = module.monitoring.log_analytics_workspace_id
  app_insights_connection_string = module.monitoring.application_insights_connection_string

  app_service_plan_sku = var.app_service_plan_sku
  site_config          = var.frontend_site_config
}

module "messaging" {
  source = "./modules/messaging"

  name_suffix         = local.name_suffix
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  log_analytics_workspace_id     = module.monitoring.log_analytics_workspace_id
  app_insights_connection_string = module.monitoring.application_insights_connection_string

  storage_account_id        = module.data.storage_account_id
  raw_container_name        = module.data.storage_container_names["raw"]
  servicebus_namespace_name = module.data.servicebus_namespace_name
  scan_results_queue_id     = module.data.servicebus_queue_ids["scan-results"]

  signalr_sku_name              = var.signalr_sku_name
  email_data_location           = var.email_data_location
  function_plan_sku             = var.function_plan_sku
  enable_eventgrid_topic        = var.enable_eventgrid_topic
  enable_eventgrid_subscription = var.enable_eventgrid_subscription
}
