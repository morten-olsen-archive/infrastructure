[Interface]
Address = ${network_range}.1/${network_mask}
ListenPort = 51820
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
PrivateKey = ${host_key}

%{ for client in clients ~}
[Peer] # NAME
PublicKey = ${client.public_key}
AllowedIPs = ${client.ip}/32

%{ endfor ~}

