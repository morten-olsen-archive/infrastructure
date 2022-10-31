[Interface]
Address = ${network_range}.${ip}
PrivateKey = ${private_key}
DNS = ${dns}

[Peer]
PublicKey = ${host_public_key}
AllowedIPs = 0.0.0.0/0
Endpoint = ${host_address}:51820
PersistentKeepalive = 25
