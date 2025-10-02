data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = "kv-${var.name_prefix}-${var.location_short}-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
  tags                = var.tags

  # Network access
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  # Access policies
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]

    certificate_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers"
    ]
  }

  # Enable purge protection
  purge_protection_enabled   = true
  soft_delete_retention_days = 90
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Private endpoint for Key Vault
resource "azurerm_private_endpoint" "this" {
  name                = "pe-${var.name_prefix}-keyvault-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-keyvault"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "keyvault-dns-zone"
    private_dns_zone_ids = [var.keyvault_private_dns_zone_id]
  }
}

# Sample secrets for the hello-api application
resource "azurerm_key_vault_secret" "hello_api_config" {
  name = "hello-api-config"
  value = jsonencode({
    message     = "Hello from Azure Key Vault!"
    version     = "1.0.0"
    environment = "production"
  })
  key_vault_id = azurerm_key_vault.this.id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "hello_api_database_url" {
  name         = "hello-api-database-url"
  value        = "postgresql://hello-api:password@database.example.com:5432/hello_api"
  key_vault_id = azurerm_key_vault.this.id
  tags         = var.tags
}
