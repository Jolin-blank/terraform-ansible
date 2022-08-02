terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.76.3"
    }
  }
}

provider "tencentcloud" {

  region = "ap-bangkok"
}
