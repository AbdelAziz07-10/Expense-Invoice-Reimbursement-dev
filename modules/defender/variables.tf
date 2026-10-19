variable "enable_malware_scanning" {
  description = "Enable Microsoft Defender for Storage with on-upload malware scanning. Subscription-level; needs Security Admin/Owner."
  type        = bool
  default     = false
}

variable "scan_cap_gb_per_month" {
  description = "Monthly malware scanning cap per storage account in GB, to limit cost."
  type        = number
  default     = 10
}
