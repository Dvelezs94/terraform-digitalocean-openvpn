output "droplet_ip" {
  description = "Droplet IPv4 public IP"
  value       = digitalocean_droplet.vpn.ipv4_address
}