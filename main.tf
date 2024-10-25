variable "proxmox_url" {}
variable "pm_password" {}
variable "pm_user" {}
variable "target_node" {}
variable "root_password" {}
variable "vm_name" {}
variable "cores" {}
variable "memory" {}
variable "disk_size" {}
variable "clone" {}
variable "ipconfig0" {}
variable "nameserver" {}
variable "ssh_key" {}
variable "disk_storage" {}
variable "cloudinit_storage" {}


terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}


provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://${var.proxmox_url}:8006/api2/json"
  pm_password     = "${var.pm_password}"
  pm_user         = "${var.pm_user}"
  pm_otp          = ""
  pm_log_enable   = true
  pm_log_file     = "terraform-plugin-proxmox.log"
  pm_debug        = true
  pm_log_levels   = {
    _default    = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "cloudinit" {
  name          = var.vm_name
  target_node   = var.target_node
  agent         = 1
  cores         = var.cores
  memory        = var.memory
  boot          = "order=scsi0"
  clone         = var.clone
  scsihw        = "virtio-scsi-single"
  vm_state      = "running"
  automatic_reboot = true
  os_type       = "cloud-init"
  ciupgrade     = true
  nameserver    = var.nameserver
  ipconfig0     = var.ipconfig0
  skip_ipv6     = true
  ciuser        = "root"
  cipassword    = var.root_password
  sshkeys       = var.ssh_key
  
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.disk_storage
          size    = "${var.disk_size}"
        }
      }
    }
    ide {
      ide3 {
        cloudinit {
          storage = var.cloudinit_storage
        }
      }
    }
  }

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
}
