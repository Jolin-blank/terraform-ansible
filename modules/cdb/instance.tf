terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.76.3"
    }
  }
}

resource "tencentcloud_mysql_instance" "default" {
  engine_version    = "5.7"
  charge_type       = "POSTPAID"
  slave_deploy_mode = 0 
  slave_sync_mode   = 0
  availability_zone = var.az 
  first_slave_zone  = var.az
  instance_name     = var.name
  mem_size          = var.dbmemory 
  volume_size       = var.volsize
  vpc_id            = var.vpc 
  subnet_id         = var.subnet_id 
  root_password     = "Root2020@@"
  param_template_id = 16295
  intranet_port     = 13357
  internet_service  = 0
  tags = {
    name = "test"
  }

  parameters = {
    max_connections = "1000"
    character_set_server = "UTF8"
  }
}
data "tencentcloud_instances_set" "ip_lists" {
     instance_name = "salt" 
}
resource "tencentcloud_mysql_account" "default" {
  mysql_id =  tencentcloud_mysql_instance.default.id
  name = var.db_username
  password = var.db_passwd
  depends_on = [
      tencentcloud_mysql_account.default
  ] 
}
resource  "tencentcloud_mysql_account_privilege" "default" {
  mysql_id = tencentcloud_mysql_instance.default.id 
  account_name = var.db_username
  privileges = ["SELECT","INSERT","UPDATE","DELETE","CREATE","DROP","REFERENCES","INDEX","ALTER","CREATE TEMPORARY TABLES","LOCK TABLES","EXECUTE","CREATE VIEW","SHOW VIEW","CREATE ROUTINE","ALTER ROUTINE","EVENT","TRIGGER"]
  database_names = [var.name]  
  depends_on = [
      tencentcloud_mysql_account.default
   ]
}
