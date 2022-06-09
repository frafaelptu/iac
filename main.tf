terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token  
}


resource "digitalocean_kubernetes_cluster" "k8s_devops" {
  name   = var.k8s_name
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.22.8-do.1"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 3    
  }
}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_devops.kube_config.0.raw_config
    filename = "${path.module}/kube_config.yaml"
}

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
    value = digitalocean_kubernetes_cluster.k8s_devops.endpoint
}

#resource "digitalocean_kubernetes_node_pool" "node_premium" {
#  cluster_id = digitalocean_kubernetes_cluster.k8s_devops.id
#  name       = "premium"
#  size       = "s-4vcpu-8gb"
#  node_count = 2
#}