resource "cloudstack_instance" "bastion" {
  name             = "idcfc-west-bastion"
  service_offering = "light.S1"
  network_id       = var.network_id
  template         = "Rocky Linux 8.4 64-bit"
  zone             = var.zone
  keypair          = cloudstack_ssh_keypair.id_rsa.name
  expunge          = true
}

resource "cloudstack_instance" "workstation" {
  name             = "idcfc-west-workstation"
  service_offering = "standard.S8"
  network_id       = var.network_id
  template         = "Rocky Linux 8.4 64-bit"
  zone             = var.zone
  keypair          = cloudstack_ssh_keypair.id_rsa.name
  root_disk_size   = 80
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

resource "cloudstack_ssh_keypair" "id_rsa" {
  name       = "id.rsa"
  public_key = file("~/.ssh/id_rsa.pub")
}
