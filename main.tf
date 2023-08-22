# Create Private DNS Zone
resource "azurerm_private_dns_zone" "dns-zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

# Create Private DNS Zone Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = "vnet_link"
  resource_group_name = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
  virtual_network_id    = var.vnetid
}

# Create Storage Account
resource "azurerm_storage_account" "mystorageprac" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  public_network_access_enabled = false
}

# Create Private Endpint
resource "azurerm_private_endpoint" "endpoint" {
  name                = "my-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.pesubnetid

  private_service_connection {
    name                           = "my-psc"
    private_connection_resource_id = azurerm_storage_account.mystorageprac.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  depends_on = [ azurerm_storage_account.mystorageprac ]
}

# Create DNS A Record
resource "azurerm_private_dns_a_record" "dns_a" {
  name                = "mydns"
  zone_name           = azurerm_private_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
}

resource "azurerm_storage_container" "mycontainer" {
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.mystorageprac.name
  container_access_type = "private"
}

# resource "azurerm_storage_blob" "blob" {
#   name                   = "my-awesome-content.zip"
#   storage_account_name   = azurerm_storage_account.mystorageprac.name
#   storage_container_name = azurerm_storage_container.mycontainer.name
#   type                   = "Block"
#   source                 = "some-local-file.zip"
# }