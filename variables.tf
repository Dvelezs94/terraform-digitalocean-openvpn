variable "droplet_name" {
  type        = string
  description = "Identifier name for the droplet"
  default     = "OpenVPN-server"
}

variable "droplet_size" {
  type        = string
  description = "Droplet size"
  default     = "s-1vcpu-1gb"
}

variable "droplet_region" {
  type        = string
  description = "Droplet region"
  default     = "sfo3"
}

variable "do_ssh_key_name" {
  type        = string
  description = "SSH key name you want to use for root user. This asumes you have an existing SSH key set up in your DO account"
}

variable "ssh_key_path" {
  type        = string
  description = "local path to the SSH pem key to connect to server."
}

variable "openvpn_devices" {
  type        = list(string)
  description = "List of devices you will connect to the vpn. It should be 1 per device. An .ovpn file will get generated for each"
  default     = []
}