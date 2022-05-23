output "droplet_ip" {
  description = "Droplet IPv4 public IP"
  value       = digitalocean_droplet.vpn.ipv4_address
}

output "droplet_id" {
  description = "Droplet id"
  value       = digitalocean_droplet.vpn.id
}

output "droplet_urn" {
  description = "Droplet urn"
  value       = digitalocean_droplet.vpn.urn
}