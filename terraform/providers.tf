terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }

    wireguard = {
      source  = "OJFord/wireguard"
      version = "0.2.1+1"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "2.11.1"
    }
  }
}

provider "docker" {
  host = local.docker.host
}

provider "wireguard" {
}

provider "cloudflare" {
  api_token = local.cloudflare.api_token
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
