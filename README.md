# Infrastructure terraformed

This is my personal infrastructure that I am revamping and rewriting in Terraform.
This project is only made public for reference, and will most likely not be usable as-is, unless you want a setup exactly identical to mine - if, then feel free!

## Setup

Start by copying `envs/sample` into `envs/{your-env-name}` and update any relevant values. Not all possible configurations are shown in the sample

Next `cd terraform` and run `terraform init && terraform workspace new {your-env-name}`

You are good to go, so to deploy the infrastrucure just run `terraform apply`

After you will have a folder called `output/{your-env-name}` which contains client configs for accessing the VPN

## Roadmap

- [ ] Core network
  - [x] Auto configure CloudFlare DNS
  - [x] Wireguard VPN
    - [x] Auto client generation
  - [x] VPN DNS
  - [x] Network DNS
  - [x] TLS certificates
  - [x] HTTPS proxy
  - [x] Proxy for internal traffic
  - [x] Basic storage setup
  - [ ] Additional DNS records
  - [ ] Additional proxy targets
  - [x] Mount NAS (GlusterFS)
  - [ ] Uptime monitor/alerts
  - [ ] Logging (?)
- [ ] Network (Unifi)
  - [ ] Auto configure port forwards
  - [ ] Terraform based firewall rules
  - [ ] Terraform based device setup
  - [ ] Terraform based port setup
- [ ] Utils
  - [x] Multi environment support
  - [x] Proxy utils
  - [ ] Backup solution
    - [x] Mount services for backup
    - [x] Mount media for backup
    - [ ] Auto configure app backup
    - [ ] Configure media backup in terraform
- [ ] Main services
  - [x] jellyfin
  - [x] calibre-web
  - [x] duplicati
  - [x] vaultwarden
  - [ ] syncthing
  - [ ] keycloak
  - [x] radicale
  - [x] freshrss
  - [ ] gitea
    - [ ] drone-ci
  - [x] wallabag
  - [ ] code playground
  - [x] gotify
  - [ ] music
    - [x] subsonic compatible server
    - [ ] mpd
    - [ ] snapcast
  - [ ] service dashboard
    - [ ] internal
    - [ ] external
