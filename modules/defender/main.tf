resource "azurerm_security_center_subscription_pricing" "storage" {
  count = var.enable_malware_scanning ? 1 : 0

  resource_type = "StorageAccounts"
  tier          = "Standard"
  subplan       = "DefenderForStorageV2"

  extension {
    name = "OnUploadMalwareScanning"
    additional_extension_properties = {
      CapGBPerMonthPerStorageAccount = tostring(var.scan_cap_gb_per_month)
    }
  }

  extension {
    name = "SensitiveDataDiscovery"
  }
}
