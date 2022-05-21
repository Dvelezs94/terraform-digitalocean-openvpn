#!/usr/bin/expect
set timeout -1

# CA always has a password for protection in event server is compromised. The
# password is only needed to sign client/server certificates.  No password is
# needed for normal OpenVPN operation.
# Refer to kylemanna docs here if you want to enable CA password
# https://github.com/kylemanna/docker-openvpn/blob/master/bin/ovpn_initpki
spawn docker-compose run --rm openvpn ovpn_initpki nopass
expect "Common Name "
send -- "openvpn\r"
expect eof
