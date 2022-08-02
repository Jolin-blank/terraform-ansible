terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.76.3"
    }
  }
}

data "tencentcloud_instance_types" "my_favorite_instance_types" {
   filter {
    name   = "instance-family"
    values = ["S5"]
  }
  cpu_core_count = var.cpucore  
  memory_size    = var.mem
}

data "tencentcloud_availability_zones" "my_favorite_zones" {
   name = "ap-bangkok-2"
}


// Create 2 CVM instances to host awesome_app
resource "tencentcloud_instance" "cvm" {
  instance_name     = var.instance
  availability_zone = data.tencentcloud_availability_zones.my_favorite_zones.zones.0.name
  image_id          = var.image 
  instance_type     = data.tencentcloud_instance_types.my_favorite_instance_types.instance_types.0.instance_type
  system_disk_type  = "CLOUD_PREMIUM"
  system_disk_size  = 50
  hostname          = "yum"
  vpc_id            = var.vpc 
  subnet_id         = var.subnet 
  count             = var.cvmno
  password = var.root_password 
  
  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 100
    encrypt        = false
  }
   

  tags = {
    tagKey = "tagValue"
  }
}
