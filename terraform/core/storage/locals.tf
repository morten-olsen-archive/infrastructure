locals {
  namespace = var.namespace
  slow      = var.storage.media
  movies    = "${local.slow}/movies"
  tvshows   = "${local.slow}/tv-shows"
  music     = "${local.slow}/music"
  books     = "${local.slow}/books"
}
