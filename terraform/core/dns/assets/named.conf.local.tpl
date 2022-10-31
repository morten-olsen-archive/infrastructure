%{ for zone in zones ~}
zone "${zone.name}" {
    type master;
    file "/etc/bind/zones/db.${zone.name}";
};
%{ endfor ~}
