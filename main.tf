resource "cloudstack_instance" "bastion" {
  name             = "bastion"
  service_offering = "light.S1"
  network_id       = var.network_id
  template         = "Rocky Linux 8.4 64-bit"
  zone             = var.zone
  keypair          = "id_rsa"
  expunge          = true
}

resource "cloudstack_ipaddress" "public_ipaddress" {
  network_id = var.network_id
  zone       = var.zone
}

resource "cloudstack_port_forward" "pf_ssh" {
  ip_address_id = cloudstack_ipaddress.public_ipaddress.id
  forward {
    protocol           = "tcp"
    private_port       = 22
    public_port        = 22
    virtual_machine_id = cloudstack_instance.bastion.id
  }
}

resource "cloudstack_firewall" "my_ip" {
  ip_address_id = cloudstack_ipaddress.public_ipaddress.id
  rule {
    cidr_list = ["${var.my_ip}/32"]
    protocol  = "tcp"
    ports     = ["22"]
  }
}