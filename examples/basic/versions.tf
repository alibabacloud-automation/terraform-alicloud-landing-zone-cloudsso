terraform {
  required_version = ">= 1.3.10"
  required_providers {
    alicloud = {
      source  = "hashicorp/alicloud"
      version = " >= 1.145.0"
    }
  }
}