resource "docker_image" "main" {
  count = local.server.share == null ? 0 : 1
  name  = "${local.namespace}-gluster"
  build {
    path = "${path.module}/docker"
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "docker/*") : filesha1("${path.module}/${f}")]))
  }
}

resource "docker_container" "gluster" {
  name         = "${local.namespace}-gluster"
  count        = local.server.share == null ? 0 : 1
  image        = docker_image.main[0].image_id
  restart      = "unless-stopped"
  privileged   = true
  network_mode = "host"
  env = [
    "GLUSTER=${local.server.share}"
  ]

  mounts {
    type   = "bind"
    source = local.target
    target = "/srv"
    bind_options {
      propagation = "rshared"
    }
  }

  mounts {
    type      = "bind"
    target    = "/sys/fs/cgroup"
    source    = "/sys/fs/cgroup"
    read_only = true
  }
}
