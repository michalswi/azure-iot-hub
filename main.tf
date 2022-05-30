variable "public_ip" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.location
}


# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub
resource "azurerm_iothub" "iothub" {
  name                = "${var.name}-iot-hub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    # Free Tier
    # https://azure.microsoft.com/en-us/pricing/details/iot-hub/ 
    name     = "F1"
    capacity = "1"
  }

  public_network_access_enabled = true

  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#network_rule_set
  # portal / IoT Hub / Networking / Public network access: Selected IP ranges
  network_rule_set {
    default_action = "Deny"
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#ip_rule
    ip_rule {
      name    = "myIP"
      ip_mask = var.public_ip
      action  = "Allow"
    }
  }

  tags = {
    purpose = "demo"
  }
}

resource "null_resource" "iot_device" {
  triggers = {
    iot_hub_name   = azurerm_iothub.iothub.name
    iot_hub_device = var.iot_device
  }
  provisioner "local-exec" {
    command = <<EOF
      echo ${self.triggers.iot_hub_name}
      echo ${self.triggers.iot_hub_device}
      export IOT_HUB_NAME=${self.triggers.iot_hub_name}
      export IOT_HUB_DEVICE_NAME=${self.triggers.iot_hub_device}
      bash ${path.module}/scripts/device.sh create
    EOF
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      echo ${self.triggers.iot_hub_name}
      echo ${self.triggers.iot_hub_device}
      export IOT_HUB_NAME=${self.triggers.iot_hub_name}
      export IOT_HUB_DEVICE_NAME=${self.triggers.iot_hub_device}
      bash ${path.module}/scripts/device.sh delete
    EOF
  }
}
