output "cvm_addrs" {
  value =  tencentcloud_instance.cvm[*].private_ip
}

