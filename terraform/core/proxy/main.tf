resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = local.admin_email
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = local.zone
  subject_alternative_names = [
    "*.${local.zone}",
  ]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CF_DNS_API_TOKEN = local.cloudflare.api_token
    }
  }
}

resource "acme_certificate" "certificate_external" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = local.zone
  subject_alternative_names = [
    "*.${local.external_subdomain}.${local.zone}",
  ]

  depends_on = [
    acme_certificate.certificate
  ]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CF_DNS_API_TOKEN = local.cloudflare.api_token
    }
  }
}

resource "acme_certificate" "certificate_internal" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = local.zone
  subject_alternative_names = [
    "*.${local.internal_subdomain}.${local.zone}",
  ]

  depends_on = [
    acme_certificate.certificate_external
  ]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CF_DNS_API_TOKEN = local.cloudflare.api_token
    }
  }
}

data "cloudflare_zone" "main" {
  name = local.zone
}

resource "cloudflare_record" "main" {
  zone_id = data.cloudflare_zone.main.id
  name    = "*.${local.external_subdomain}"
  value   = local.host.ip.external
  type    = "A"
  ttl     = 3600
}

resource "docker_network" "proxy_network" {
  name = "${local.namespace}-proxy"
}

resource "docker_container" "traefik" {
  name    = "${local.namespace}-proxy"
  image   = "traefik:latest"
  restart = "unless-stopped"

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  upload {
    file    = "/etc/tls/cert.pem"
    content = acme_certificate.certificate.certificate_pem
  }

  upload {
    file    = "/etc/tls/key.pem"
    content = acme_certificate.certificate.private_key_pem
  }

  upload {
    file    = "/etc/tls/external-cert.pem"
    content = acme_certificate.certificate_external.certificate_pem
  }

  upload {
    file    = "/etc/tls/external-key.pem"
    content = acme_certificate.certificate_external.private_key_pem
  }

  upload {
    file    = "/etc/tls/internal-cert.pem"
    content = acme_certificate.certificate_internal.certificate_pem
  }

  upload {
    file    = "/etc/tls/internal-key.pem"
    content = acme_certificate.certificate_internal.private_key_pem
  }

  upload {
    file = "/etc/traefik/traefik.toml"
    content = templatefile(
      "${path.module}/assets/config.tpl",
      {
        network = docker_network.proxy_network.name
      }
    )
  }

  upload {
    file = "/etc/traefik/tls.yml"
    content = templatefile(
      "${path.module}/assets/tls.tpl",
      {
        cert          = "/etc/tls/cert.pem"
        key           = "/etc/tls/key.pem"
        external_cert = "/etc/tls/external-cert.pem"
        external_key  = "/etc/tls/external-key.pem"
        internal_cert = "/etc/tls/internal-cert.pem"
        internal_key  = "/etc/tls/internal-key.pem"
      }
    )
  }

  networks_advanced {
    name = docker_network.proxy_network.name
  }

  networks_advanced {
    name         = local.vpn.network.name
    ipv4_address = local.vpn.ip
  }

  mounts {
    read_only = true
    type      = "bind"
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
  }

  dynamic "labels" {
    for_each = local.internal_labels
    content {
      label = labels.key
      value = labels.value
    }
  }

  labels {
    label = "traefik.http.routers.traefik.rule"
    value = "Host(`proxy.${local.internal_domain}`)"
  }

  labels {
    label = "traefik.http.routers.traefik.service"
    value = "api@internal"
  }

  labels {
    label = "traefik.http.routers.traefik.middlewares"
    value = "strip"
  }

  labels {
    label = "traefik.http.middlewares.strip.stripprefix.prefixes"
    value = "/traefik"
  }
}
