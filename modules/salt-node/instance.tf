provider "google" {
  project = "futu-testing"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "salt_vm_instance" {
  count  =3
  name         = "salt-node-${count.index}"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default" 
  }
  metadata =  {
     ssh-keys = "futu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRmU1RWbAUnyyUxo/+Qn4NgZvJMRFvNIoQpo5zrwwZSBNw5GAbk0ksW/zbPVKBMrfn/LQZFR+ihrB8JV1QcedTC7dHocXpY/71dgxjxrYLs9L+a0dt03CB72+FkoTCtC3sViIn9grxWoK8OtVSchi6Tq0CeHYQCegZZ/bs/qYdoNeuhQNZhd3GkzOG720SVHonb65hYNbbZZK9aYQkl1kB2ftd0FfURQUamDKMZcJl7jD/MNIyXH+jJVexVJVnRjjx4uhZI4MJ6PmjpUAbRiBdOb00obR8vn69/pYDABkN+bUUbGCTGr2xlj0IaiHo4gYbLgYqKKTF7KyyixfOAhYZ" 
   }
#   connection {
#    type     = "ssh"
#    user     = "futu"
#    private_key = file("~/.ssh/id_rsa")
#    host     = self.network_interface.0.access_config.0.nat_ip
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sudo yum install ansible -y"
#    ]
#  }
  
}

