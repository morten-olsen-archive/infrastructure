defaults
    mode tcp

frontend webhttp
    bind :80
    default_backend webhttpinternal

frontend webhttps
    bind :443
    default_backend webhttpsinternal

backend webhttpinternal
  server webhttpinternal1 ${proxy.ip}:6080

backend webhttpsinternal
  server webhttpsinternal1 ${proxy.ip}:6443
