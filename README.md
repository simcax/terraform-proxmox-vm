# PROXMOX Terraform module for VM Creation
This module creates a VM in Proxmox 

Example execution:
```bash
terraform plan -out tf.plan -var "proxmox_url=proxmox.example.com" -var "pm_password=bigsecret" -var "pm_user=provisioner@pve" -var "target_node=proxmox" -var "root_password=evenbiggersecret" -var "vm_name=best-vm-ever" -var "cores=4" -var "memory=4096" -var "disk_size=50" -var "clone=VM template" -var "ipconfig0=ip=10.0.0.10/24,gw=10.0.0.1" -var "nameserver=10.0.0.1" -var "ssh_key=ssh-rsa ...." -var "disk_storage=local-lvm" -var "cloudinit_storage=local-lvm"
```