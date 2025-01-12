# Topic 1

resource "yandex_resourcemanager_folder_iam_member" "sa" {
  folder_id = var.folder_id
  role      = "admin"
  member = "serviceAccount:${var.service_account_id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "bucket-diplom" {
  bucket                = var.bucket_name
  folder_id             = var.folder_id
  default_storage_class = "standard"
  force_destroy         = true

  access_key = var.access_key
  secret_key = var.secret_key
}


resource "yandex_vpc_network" "my_vpc" {
  name = var.VPC_name
}

resource "yandex_vpc_subnet" "public_subnet" {
  count = length(var.public_subnet_zones)
  name  = "${var.public_subnet_name}-${var.public_subnet_zones[count.index]}"
  v4_cidr_blocks = [
    cidrsubnet(var.public_v4_cidr_blocks[0], 4, count.index)
  ]
  zone       = var.public_subnet_zones[count.index]
  network_id = yandex_vpc_network.my_vpc.id
}

# Topic 2

resource "yandex_compute_instance" "master-node" {
  name            = var.master_name
  platform_id     = var.platform
  zone            = var.public_subnet_zones[0]
  resources {
    cores         = var.master_core
    memory        = var.master_memory
    core_fraction = var.master_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.master_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.scheduling_policy
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet[0].id
    nat       = var.nat
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"

 }
}

resource "yandex_compute_instance" "worker" {
  count           = var.worker_count
  name            = "worker-node-${count.index + 1}"
  platform_id     = var.worker_platform
  zone = var.public_subnet_zones[count.index]
  resources {
    cores         = var.worker_cores
    memory        = var.worker_memory
    core_fraction = var.worker_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.worker_disk_size
    }
  }

    scheduling_policy {
    preemptible = var.scheduling_policy
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet[count.index].id
    nat       = var.nat
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"

 }
}
