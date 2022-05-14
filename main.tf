terraform {
  cloud {
    organization = "sebbycorp"

    workspaces {
      name = "f5-tf-bigip-prod"
    }
  }
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.13.1"
    }
  }
}

provider "bigip" {
  address  = var.bigipmgmt
  username = var.bigipmgmtuser
  password = var.bigippass
}



data "template_file" "init" {
  template = file("bigip.tpl")
  vars = {
    HOSTNAME         = "bigip-prod.maniak.academy"
    DNS_ADDRESS      = "8.8.8.8"
    NTP_ADDRESS      = "8.8.8.8"
    GUEST_PASSWORD   = "W3lcome098!"
    EXTERNAL_ADDRESS = "10.20.0.100/24"
    EXTERNAL_VLAN_ID = "1"
    INTERNAL_ADDRESS = "10.10.0.100/24"
    INTERNAL_VLAN_ID = "2"
    DEFAULT_ROUTE    = "10.20.0.1"
    ALLOWED_IP       = "192.168.0.0/16"
  }
}
resource "bigip_do" "do-deploy" {
  do_json = data.template_file.init.rendered
}


