$TTL    604800
@       IN      SOA     ns1.${zone}. root.${zone}. (
                  3       ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL
;
; name servers - NS records
     IN      NS      ns1.${zone}.

; name servers - A records
ns1.${zone}.          IN      A      ${dns_ip}

%{ for record in records ~}
${record.name}.${zone}. IN ${record.type} ${record.value}

%{ endfor ~}
