terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.4"

  backend "s3" {
    endpoint                    = "https://storage.yandexcloud.net"
    bucket                      = "bucket-lebedevai"
    region                      = "ru-central1-b"
    key                         = "terraform.tfstate"
    access_key                  = "access_key"
    secret_key                  = "secret_key"
    skip_region_validation      = true
    skip_credentials_validation = true
#    skip_requesting_account_id  = true
#    skip_s3_checksum            = true
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-b"
}
