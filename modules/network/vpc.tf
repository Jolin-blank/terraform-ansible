terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.76.3"
    }
  }
}
// Create VPC resource
resource "tencentcloud_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  name       = "test-env"
}

resource "tencentcloud_subnet" "default" {
  vpc_id            = tencentcloud_vpc.default.id
  availability_zone = var.az 
  name              = var.subnetname
  cidr_block        = "10.0.2.0/24"
  depends_on = [
     tencentcloud_vpc.default
  ]
}

