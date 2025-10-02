# User-Assigned Managed Identity for AKS kubelet
resource "azurerm_user_assigned_identity" "kubelet" {
  name                = "uami-${var.name_prefix}-kubelet-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# User-Assigned Managed Identity for external-dns
resource "azurerm_user_assigned_identity" "external_dns" {
  name                = "uami-${var.name_prefix}-external-dns-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# User-Assigned Managed Identity for external-secrets
resource "azurerm_user_assigned_identity" "external_secrets" {
  name                = "uami-${var.name_prefix}-external-secrets-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# User-Assigned Managed Identity for CSI Key Vault driver
resource "azurerm_user_assigned_identity" "csi_keyvault" {
  name                = "uami-${var.name_prefix}-csi-keyvault-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Role assignment for external-dns (DNS Zone Contributor)
resource "azurerm_role_assignment" "external_dns_dns_contributor" {
  scope                = var.dns_zone_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.external_dns.principal_id
}

# Role assignment for external-secrets (Key Vault Secrets User)
resource "azurerm_role_assignment" "external_secrets_kv_secrets_user" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.external_secrets.principal_id
}

# Role assignment for CSI Key Vault driver (Key Vault Secrets User)
resource "azurerm_role_assignment" "csi_keyvault_kv_secrets_user" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.csi_keyvault.principal_id
}
