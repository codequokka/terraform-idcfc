variable "api_key" {}
variable "secret_key" {}
variable "my_ip" {}
variable "api_url" {}
variable "network_id" {}
variable "ip_address_id" {}

terraform {
  required_providers {
    cloudstack = {
      source  = "cloudstack/cloudstack"
      version = "0.4.0"
    }
  }
}

provider "cloudstack" {
  api_url    = var.api_url
  api_key    = var.api_key
  secret_key = var.secret_key
}

resource "cloudstack_instance" "bastion" {
  name             = "bastion"
  service_offering = "light.S1"
  network_id       = var.network_id
  template         = "Rocky Linux 8.4 64-bit"
  zone             = "augusta"
  keypair          = "id_rsa"
  expunge          = true
}

# resource "cloudstack_ipaddress" "public_ipaddress" {
#   network_id = var.network_id
#   zone       = "augusta"
# }

resource "cloudstack_port_forward" "pf_ssh" {
  ip_address_id = var.ip_address_id
  forward {
    protocol           = "tcp"
    private_port       = 22
    public_port        = 22
    virtual_machine_id = cloudstack_instance.bastion.id
  }
}

resource "cloudstack_firewall" "my_ip" {
  ip_address_id = var.ip_address_id
  rule {
    cidr_list = ["${var.my_ip}/32"]
    protocol  = "tcp"
    ports     = ["1-65535"]
  }
}

# output "public_ipaddress" {
#   value = cloudstack_ipaddress.public_ipaddress.ip_address
# }
