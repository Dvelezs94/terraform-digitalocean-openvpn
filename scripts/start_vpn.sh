#!/bin/bash
docker-compose up -d openvpn

# start docker on system restart
systemctl enable docker