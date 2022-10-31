[providers.file]
  filename = "/etc/traefik/tls.yml"

[providers.docker]
  network = "${network}"
  exposedByDefault = false

[api]
  dashboard = true

[entrypoints]
  [entrypoints.externalHttp]
    address = ":80"
    [entrypoints.externalHttp.http.redirections.entrypoint]
      to = "external"
      scheme = "https"

  [entrypoints.external]
    address = ":443"
    [entrypoints.external.http]
      tls = true

  [entrypoints.internalHttp]
    address = ":6080"
    [entrypoints.internalHttp.http.redirections.entrypoint]
      to = "internal"
      scheme = "https"

  [entrypoints.internal]
    address = ":6443"
    [entrypoints.internal.http]
      tls = true

