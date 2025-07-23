# random dolgok:

## tag csere docker image-en:

    sudo docker tag <image_tag:verzio> <new_image_name:verzio>
    sudo docker rmi <image_tag:verzio> # ha már nincs rá szükség
    docker image check:
    sudo docker images


## docker containerek törlése:

    sudo docker rm -f $(sudo docker ps -aq) # force delete all containers


## docker containerek listázása:

    sudo docker ps -a # list all containers
    sudo docker ps # list running containers

## clab hostok ip-konfigurációja:

    ifconfig <eth_port> <ip_address> netmask <netmask> up
    route add default gw <gateway_ip> 


## Mappastruktúra

```bash
.
├── notes.md
├── bgp/
    ├── big/                                # "bonyolultabb" topológiák
        ├── clab-bgp-multisite-network      # feladat directory
            ├── ...
            ├── network-topology.clab.yml   # feladat topológiája
            ├── readme.md                   # dokumentáció 
    ├── small/                              # egyszerűbb topológiák
        ├── ...
    ├── ...
├── configs-backup/                         # backup directory
│   ├──bgp-multisite-network
│       ├── bud-r1
│       ├── bud-r2
│       ├── ...
├── config-backup.sh                        # backup/restore script
└── diagrams/                               # még nincs ilyen, de lesz kiegészítés
    └── topology.png
```
