locals {
  assignments = {
    brain_blob_contributor = {
      principal_id = var.identities["brain"].principal_id
      scope        = var.storage_account_id
      role         = "Storage Blob Data Contributor"
    }
    brain_sb_sender = {
      principal_id = var.identities["brain"].principal_id
      scope        = var.servicebus_namespace_id
      role         = "Azure Service Bus Data Sender"
    }
    brain_sb_receiver = {
      principal_id = var.identities["brain"].principal_id
      scope        = var.servicebus_namespace_id
      role         = "Azure Service Bus Data Receiver"
    }
    brain_signalr = {
      principal_id = var.identities["brain"].principal_id
      scope        = var.signalr_id
      role         = "SignalR App Server"
    }
    ocr_blob_contributor = {
      principal_id = var.identities["ocr"].principal_id
      scope        = var.storage_account_id
      role         = "Storage Blob Data Contributor"
    }
    ocr_sb_receiver = {
      principal_id = var.identities["ocr"].principal_id
      scope        = var.servicebus_namespace_id
      role         = "Azure Service Bus Data Receiver"
    }
    ocr_sb_sender = {
      principal_id = var.identities["ocr"].principal_id
      scope        = var.servicebus_namespace_id
      role         = "Azure Service Bus Data Sender"
    }
    function_sb_receiver = {
      principal_id = var.identities["function"].principal_id
      scope        = var.servicebus_namespace_id
      role         = "Azure Service Bus Data Receiver"
    }
  }

  eventgrid_assignments = var.enable_eventgrid_assignment ? {
    eventgrid_sb_sender = {
      principal_id = var.eventgrid_principal_id
      scope        = var.servicebus_namespace_id
      role         = "Azure Service Bus Data Sender"
    }
  } : {}

  all_assignments = var.enable_role_assignments ? merge(local.assignments, local.eventgrid_assignments) : {}
}

resource "azurerm_role_assignment" "this" {
  for_each = local.all_assignments

  principal_id         = each.value.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_type       = "ServicePrincipal"
}
