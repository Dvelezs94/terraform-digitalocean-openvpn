# terraform-do-openvpn
Terraform module which deploys OpenVPN with docker on DigitalOcean.

This terraform works alongside kylemanna [OpenVPN implementation](https://hub.docker.com/r/kylemanna/openvpn). If you want to make changes to OpenVPN itself, refer to his docs [here](https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md)

Note: by default CA password protection is disabled. if you want to enable refer to [kylemanna's docs](https://github.com/kylemanna/docker-openvpn/blob/master/bin/ovpn_initpki)

This terraform asumes you have an existing SSH key created in your digitalocean account, which it uses to SSH into the openvpn server.
To access to your SSH settings in your DO account go to `Settings > Security` or [follow this link](https://cloud.digitalocean.com/account/security)

# Quickstart

```
module "openvpn" {
  source          = "Dvelezs94/terraform-digitalocean-openvpn"
  version         = "0.1.4"
  do_ssh_key_name = "mySSHKey"
  ssh_key_path    = "~/.ssh/mysshkey.pem"
  openvpn_devices = ["my_laptop", "cellphone", "my_tablet"]
}
```

If you want to rerun the openvpn setup scripts run these commands

```
terraform destroy -target module.openvpn.null_resource.install_openvpn
terraform apply
```

For revoking certificates you will need to manually SSH in and run the command below
Where `$CLIENTNAME` is the name you set in terraform for that profile
```
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME remove
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1 |
| <a name="requirement_remote"></a> [remote](#requirement\_remote) | ~> 0.0.24 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | ~> 2.0 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.2 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.1 |
| <a name="provider_remote"></a> [remote](#provider\_remote) | ~> 0.0.24 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.vpn](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [local_file.local_write](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.install_openvpn](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.openvpn_devices](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [digitalocean_ssh_key.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/ssh_key) | data source |
| [remote_file.ovpn_configs](https://registry.terraform.io/providers/tenstad/remote/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_do_ssh_key_name"></a> [do\_ssh\_key\_name](#input\_do\_ssh\_key\_name) | SSH key name you want to use for root user. This asumes you have an existing SSH key set up in your DO account | `string` | n/a | yes |
| <a name="input_droplet_name"></a> [droplet\_name](#input\_droplet\_name) | Identifier name for the droplet | `string` | `"OpenVPN-server"` | no |
| <a name="input_droplet_region"></a> [droplet\_region](#input\_droplet\_region) | Droplet region | `string` | `"sfo3"` | no |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | Droplet size | `string` | `"s-1vcpu-1gb"` | no |
| <a name="input_openvpn_devices"></a> [openvpn\_devices](#input\_openvpn\_devices) | List of devices you will connect to the vpn. It should be 1 per device. An .ovpn file will get generated for each | `list(string)` | `[]` | no |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | local path to the SSH pem key to connect to server. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_droplet_id"></a> [droplet\_id](#output\_droplet\_id) | Droplet id |
| <a name="output_droplet_ip"></a> [droplet\_ip](#output\_droplet\_ip) | Droplet IPv4 public IP |
| <a name="output_droplet_urn"></a> [droplet\_urn](#output\_droplet\_urn) | Droplet urn |