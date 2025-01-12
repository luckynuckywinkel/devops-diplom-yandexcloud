#output "s3_access_key" {
#  description = "Yandex Cloud S3 access key"
#  value       = yandex_iam_service_account_static_access_key.sa-static-key.access_key
#  sensitive   = true
#}

#output "s3_secret_key" {
#  description = "Yandex Cloud S3 secret key"
#  value       = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#  sensitive   = true
#}

#output "bucket_name" {
#  value = var.bucket_name
#}

#output "bucket_endpoint" {
#  value = "https://${var.bucket_name}.storage.yandexcloud.net"
#}

# Network Outputs
output "vpc_name" {
  value       = yandex_vpc_network.my_vpc.name
  description = "Name of the VPC network"
}

output "subnet_ids" {
  value       = [for subnet in yandex_vpc_subnet.public_subnet : subnet.id]
  description = "IDs of the public subnets"
}

output "subnet_names" {
  value       = [for subnet in yandex_vpc_subnet.public_subnet : subnet.name]
  description = "Names of the public subnets"
}

output "subnet_ips" {
  value       = [for subnet in yandex_vpc_subnet.public_subnet : subnet.v4_cidr_blocks]
  description = "IP addresses (CIDR blocks) of the public subnets"
}

output "subnet_zones" {
  value       = var.public_subnet_zones
  description = "Zones of the public subnets"
}

# Master Node Outputs
output "master_node_name" {
  value       = yandex_compute_instance.master-node.name
  description = "Name of the master node"
}

output "master_node_internal_ip" {
  value       = yandex_compute_instance.master-node.network_interface[0].ip_address
  description = "Internal IP address of the master node"
}

output "master_node_external_ip" {
  value       = yandex_compute_instance.master-node.network_interface[0].nat_ip_address
  description = "External IP address of the master node"
}

# Worker Nodes Outputs
output "worker_nodes_names" {
  value       = [for worker in yandex_compute_instance.worker : worker.name]
  description = "Names of the worker nodes"
}

output "worker_nodes_internal_ips" {
  value       = [for worker in yandex_compute_instance.worker : worker.network_interface[0].ip_address]
  description = "Internal IP addresses of the worker nodes"
}

output "worker_nodes_external_ips" {
  value       = [for worker in yandex_compute_instance.worker : worker.network_interface[0].nat_ip_address]
  description = "External IP addresses of the worker nodes"
}
