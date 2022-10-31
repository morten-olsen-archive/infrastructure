tls:
  stores:
    default:
      defaultCertificate:
        certFile: ${cert}
        keyFile: ${key}
  certificates:
    - certFile: ${cert}
      keyFile: ${key}
    - certFile: ${external_cert}
      keyFile: ${external_key}
    - certFile: ${internal_cert}
      keyFile: ${internal_key}
