provider "google" {
  project = "futu-testing"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "salt-node" {
   source="../modules/salt-node"
}

module "yum-node" {
   source="../modules/yum-node"
}

resource "google_compute_instance" "controll_vm_instance" {
  name         = "controll"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default" 
    access_config {
    }
  }
  metadata =  {
     ssh-keys = "futu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRmU1RWbAUnyyUxo/+Qn4NgZvJMRFvNIoQpo5zrwwZSBNw5GAbk0ksW/zbPVKBMrfn/LQZFR+ihrB8JV1QcedTC7dHocXpY/71dgxjxrYLs9L+a0dt03CB72+FkoTCtC3sViIn9grxWoK8OtVSchi6Tq0CeHYQCegZZ/bs/qYdoNeuhQNZhd3GkzOG720SVHonb65hYNbbZZK9aYQkl1kB2ftd0FfURQUamDKMZcJl7jD/MNIyXH+jJVexVJVnRjjx4uhZI4MJ6PmjpUAbRiBdOb00obR8vn69/pYDABkN+bUUbGCTGr2xlj0IaiHo4gYbLgYqKKTF7KyyixfOAhYZ" 
   }
   connection {
    type     = "ssh"
    user     = "futu"
    private_key = file("../id_rsa")
    host     = self.network_interface.0.access_config.0.nat_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install ansible -y"
    ]
  }
  provisioner "file" {
    content = templatefile("./ansible_inventory.tpl",{user="futu",salt_ip_addrs=module.salt-node.salt_node_ip_addrs,yum_ip_addrs=module.yum-node.yum_node_ip_addrs })  
    destination = "inventory"
  }
  
}

