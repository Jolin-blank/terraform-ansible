output "vpc_id" {
  value = tencentcloud_vpc.default.id 
}
output "subnet_id" {
  value = tencentcloud_subnet.default.id
}

