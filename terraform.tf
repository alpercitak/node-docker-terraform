terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:1.29.4-alpine-slim"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "node-docker-terraform-nginx"

  must_run          = true
  restart           = "always"
  publish_all_ports = false
  depends_on = [
    docker_container.app1,
    docker_container.app2
  ]
  links = [
    "node-docker-terraform-app-1:node-docker-terraform-app-1",
    "node-docker-terraform-app-2:node-docker-terraform-app-2"
  ]

  ports {
    internal = 80
    external = 3000
    protocol = "tcp"
  }

  upload {
    content = file("nginx.conf")
    file    = "/etc/nginx/nginx.conf"
  }
}

resource "docker_image" "node-docker-terraform-image" {
  name = "node-docker-terraform-image"

  build {
    path       = "."
    dockerfile = "Dockerfile"
    target     = "deploy"
  }
}

resource "docker_container" "app1" {
  image = docker_image.node-docker-terraform-image.image_id
  name  = "node-docker-terraform-app-1"

  env = ["NODE_PORT=3001", "APP_NAME=app1"]
  # entrypoint        = ["nohup", "node", "./index.js", "&"]
  must_run          = true
  restart           = "always"
  publish_all_ports = true


  upload {
    content = file("package.json")
    file    = "app/package.json"
  }

  upload {
    content = file("index.js")
    file    = "app/index.js"
  }
}

resource "docker_container" "app2" {
  image = docker_image.node-docker-terraform-image.image_id
  name  = "node-docker-terraform-app-2"

  env = ["NODE_PORT=3002", "APP_NAME=app2"]
  # entrypoint        = ["nohup", "node", "./index.js", "&"]
  must_run          = true
  restart           = "always"
  publish_all_ports = true


  upload {
    content = file("package.json")
    file    = "app/package.json"
  }

  upload {
    content = file("index.js")
    file    = "app/index.js"
  }
}
