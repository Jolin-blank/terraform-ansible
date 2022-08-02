module "vpc" {
   source = "./modules/network"
   az = "ap-bangkok-2"
   subnetname = "security_data"
}
module "salt-node" {
   source = "./modules/cvm"
   cpucore = 2
   mem=4
   image="img-l8og963d"
   instance ="salt"
   vpc = data.tencentcloud_vpc_subnets.security_data.instance_list.0.vpc_id 
   subnet = data.tencentcloud_vpc_subnets.security_data.instance_list.0.subnet_id
   root_password = var.root_password
   cvmno = 2
}
module "salt-cdb" {
  source = "./modules/cdb"
  name = "salt"
  dbmemory = 4000
  volsize = 100
  vpc = data.tencentcloud_vpc_subnets.security_data.instance_list.0.vpc_id 
  subnet_id = data.tencentcloud_vpc_subnets.security_data.instance_list.0.subnet_id
  db_username = "salt"
  db_passwd = "Salt@2022" 
  az = "ap-bangkok-2"
  depends_on = [
    module.salt-node
  ]
}

module "yum-node" {
  source = "./modules/cvm"
  cpucore = 2
  mem = 4
  image="img-l8og963d"
  instance="yum"
  vpc=data.tencentcloud_vpc_subnets.security_data.instance_list.0.vpc_id
  subnet=data.tencentcloud_vpc_subnets.security_data.instance_list.0.subnet_id
  root_password = var.root_password
  cvmno = 1
}
module "dns-ntp-node" {
  source = "./modules/cvm"
  cpucore=2
  mem=4
  image="img-l8og963d"
  instance="dns"
  vpc=data.tencentcloud_vpc_subnets.security_data.instance_list.0.vpc_id
  subnet=data.tencentcloud_vpc_subnets.security_data.instance_list.0.subnet_id
  root_password = var.root_password
  cvmno = 1
}

data "tencentcloud_instance_types" "my_favorite_instance_types" {
   filter {
    name   = "instance-family"
    values = ["S5"]
  }
  cpu_core_count = 2 
  memory_size    = 4 
}

data "tencentcloud_vpc_subnets" "security_data" {
  name = "security_data" 
  depends_on = [
    module.vpc
  ]
}


resource "tencentcloud_instance" "control-manager" {
  instance_name     = "control-manager"
  availability_zone = "ap-bangkok-2" 
  image_id          =  "img-l8og963d"
  instance_type     =  data.tencentcloud_instance_types.my_favorite_instance_types.instance_types.0.instance_type 
  system_disk_type  = "CLOUD_PREMIUM"
  system_disk_size  = 50
  hostname          = "user"
  vpc_id            = data.tencentcloud_vpc_subnets.security_data.instance_list.0.vpc_id 
  subnet_id         = data.tencentcloud_vpc_subnets.security_data.instance_list.0.subnet_id
  allocate_public_ip = true 
  internet_max_bandwidth_out = 1
  password = var.root_password

  tags = {
    tagKey = "tagValue"
  }
   connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password 
    host     = tencentcloud_instance.control-manager.public_ip
  }
  provisioner "file" {
    content = templatefile("./ansible-playbook/ansible_inventory.tpl",{user="root",salt_ip_addrs=module.salt-node.cvm_addrs,yum_ip_addrs=module.yum-node.cvm_addrs,ntp_ip_addrs=module.dns-ntp-node.cvm_addrs,password=var.root_password})  
    destination = "inventory"
  }
  provisioner "file" {
    source = "./ansible-playbook/playbook.yaml" 
    destination = "playbook.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "yum install ansible -y",
      "sed -i 's/#host_key_checking/host_key_checking/' /etc/ansible/ansible.cfg",
      "ansible-playbook -i inventory playbook.yaml"
    ]
  }
}
