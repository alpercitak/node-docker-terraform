terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

provider "docker" {}

# Create a private network for your services
resource "docker_network" "private_network" {
  name = "app_network"
}

resource "docker_image" "nginx" {
  name         = "nginx:1.29.4-alpine-slim"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "node-docker-terraform-nginx"

  # Assign to the network
  networks_advanced {
    name = docker_network.private_network.name
  }

  ports {
    internal = 80
    external = 3000
  }

  upload {
    content = file("${path.module}/nginx.conf")
    file    = "/etc/nginx/nginx.conf"
  }

  depends_on = [docker_container.app1, docker_container.app2]
}

resource "docker_image" "node_app" {
  name = "node-docker-terraform-image"
  build {
    context    = "."
    dockerfile = "Dockerfile"
    target     = "deploy"
  }
}

resource "docker_container" "app1" {
  image = docker_image.node_app.image_id
  name  = "node-docker-terraform-app-1"
  
  networks_advanced {
    name = docker_network.private_network.name
  }

  env = ["NODE_PORT=3001", "APP_NAME=app1"]
}

resource "docker_container" "app2" {
  image = docker_image.node_app.image_id
  name  = "node-docker-terraform-app-2"

  networks_advanced {
    name = docker_network.private_network.name
  }

  env = ["NODE_PORT=3002", "APP_NAME=app2"]
}