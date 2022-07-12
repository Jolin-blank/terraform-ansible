output "salt_node_ip_addrs" {

     value = google_compute_instance.salt_vm_instance[*].network_interface.0.network_ip
}

