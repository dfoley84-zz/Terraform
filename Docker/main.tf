resource "docker_image" "wordpress_id" {
  name = "wordpress:latest"
}

# Start the Container
resource "docker_container" "container_id" {
  name  = "Wordpress Site"
  image = "${docker_image.wordpress_id.latest}"

  ports {
    internal = "2368"
    external = "80"
  }
}

#Output the IP Address of the Container
output "IP Address" {
  value = "${docker_container.container_id.ip_address}"
}

output "container_name" {
  value = "${docker_container.container_id.name}"
}
