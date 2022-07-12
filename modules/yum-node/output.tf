output "yum_node_ip_addrs" {
     value = google_compute_instance.yum_instance[*].network_interface.0.network_ip
}

