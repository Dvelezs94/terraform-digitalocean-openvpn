#!/bin/bash
set -e

#cleanup
rm -rf openvpn-data/conf/pki/

PUBLIC_IP=$(curl icanhazip.com)
docker-compose run --rm openvpn ovpn_genconfig -u udp://$PUBLIC_IP
