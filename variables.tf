# -------------------------
# Azure Authentication Vars (For CI/CD)
# -------------------------
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "client_id" {
  description = "Azure Client ID (Service Principal App ID)"
  type        = string
}

variable "client_secret" {
  description = "Azure Client Secret (Service Principal Password)"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

# -------------------------
# VM Admin Password
# -------------------------
variable "admin_password" {
  description = "Admin password for the Windows VM"
  type        = string
  sensitive   = true
}
