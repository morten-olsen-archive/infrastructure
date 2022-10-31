locals {
  server = {
    share = try(var.storage.server.share, null)
  }
  namespace = var.namespace
  target    = var.storage.media
  slow      = "${local.target}/mount"
  movies    = "${local.slow}/movies"
  tvshows   = "${local.slow}/tv-shows"
  music     = "${local.slow}/music"
  books     = "${local.slow}/books"
}
