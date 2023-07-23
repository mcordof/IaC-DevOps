terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "2.23.1"
        }
    }
}

provider "docker" {
    host = "tcp://localhost:2375"
    //host = "unix:///var/run/docker.sock" ESTO SOLO FUNCIONA EN MAQUINAS UNIX
}

# Creating a Docker Image ubuntu with the latest as the Tag.
resource "docker_image" "ubuntu" {
    name = "ubuntu:latest"
}

# Creating a Docker Container using the latest ubuntu image.
resource "docker_container" "webserver" {
    image             = docker_image.ubuntu.latest
    name              = "terraform-docker-test"
    must_run          = true
    publish_all_ports = true
    command = [
        "tail",
        "-f",
        "/dev/null"
    ]
}

resource "docker_image" "nginx" {
    name         = "nginx:latest"
    keep_locally = false
}

resource "docker_container" "nginx" {
    image = docker_image.nginx.latest
    name  = "nginx-test"
    ports {
        internal = 80
        external = 8000
    }
}

