output "media" {
  value = local.slow
  depends_on = [
    docker_container.gluster
  ]
}

output "movies" {
  value = local.movies
  depends_on = [
    docker_container.gluster
  ]
}

output "tvshows" {
  value = local.tvshows
  depends_on = [
    docker_container.gluster
  ]
}

output "music" {
  value = local.music
  depends_on = [
    docker_container.gluster
  ]
}

output "books" {
  value = local.books
  depends_on = [
    docker_container.gluster
  ]
}
