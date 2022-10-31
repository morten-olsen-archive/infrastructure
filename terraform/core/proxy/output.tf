output "domains" {
  value = {
    external : local.external_domain
    internal : local.internal_domain
  }
}

output "entrypoints" {
  value = {
    external : "external"
    internal : "internal"
  }
}

output "certs" {
  value = {
    root = {
      cert = acme_certificate.certificate.certificate_pem
      key  = acme_certificate.certificate.private_key_pem
    }
    external = {
      cert = acme_certificate.certificate_external.certificate_pem
      key  = acme_certificate.certificate_external.private_key_pem
    }
    internal = {
      cert = acme_certificate.certificate_internal.certificate_pem
      key  = acme_certificate.certificate_internal.private_key_pem
    }
  }
}

output "network" {
  value = local.proxy_network
}

output "vpn" {
  value = {
    ip = local.vpn.ip
  }
}
