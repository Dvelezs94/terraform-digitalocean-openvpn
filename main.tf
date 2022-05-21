data "digitalocean_ssh_key" "main" {
  name = var.do_ssh_key_name
}

resource "digitalocean_droplet" "vpn" {
  image    = "ubuntu-20-04-x64"
  name     = var.droplet_name
  region   = var.droplet_region
  size     = var.droplet_size
  ssh_keys = [data.digitalocean_ssh_key.main.id]
}

resource "null_resource" "install_openvpn" {

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.vpn.ipv4_address
    user        = "root"
    private_key = file(var.ssh_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/scripts/docker-compose.yml"
    destination = "/root/docker-compose.yml"
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/scripts/install_dependencies.sh",
      "${path.module}/scripts/init_vpn_config.sh",
      "${path.module}/scripts/setup_vpn.sh",
      "${path.module}/scripts/start_vpn.sh",
    ]
  }

  depends_on = [digitalocean_droplet.vpn]
}

resource "null_resource" "openvpn_devices" {
  for_each = toset(var.openvpn_devices)

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.vpn.ipv4_address
    user        = "root"
    private_key = file(var.ssh_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose run --rm openvpn easyrsa build-client-full ${each.key} nopass",
      "docker-compose run --rm openvpn ovpn_getclient ${each.key} > ${each.key}.ovpn"
    ]
  }

  depends_on = [null_resource.install_openvpn]
}

# fetch .ovpn files and place them in the instantiation directory
data "remote_file" "ovpn_configs" {
  for_each = toset(var.openvpn_devices)

  conn {
    host        = digitalocean_droplet.vpn.ipv4_address
    port        = 22
    user        = "root"
    private_key = file(var.ssh_key_path)
  }

  path = "/root/${each.key}.ovpn"

  depends_on = [null_resource.openvpn_devices]
}

resource "local_file" "local_write" {
  for_each             = toset(var.openvpn_devices)
  content              = data.remote_file.ovpn_configs[each.key].content
  filename             = "${path.cwd}/ovpn_configs/${each.key}.ovpn"
  file_permission      = 0644
  directory_permission = 0755
}

