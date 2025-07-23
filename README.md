# random dolgok:
## clab telepítése:

- [így](https://containerlab.dev/install/) 
  - containerlab oldala
- [vagy így](https://juliopdx.com/2021/12/10/my-journey-and-experience-with-containerlab/) 
    - másik oldal, de több infóval, pl. docker image-ekről 
    - alapvetően ugyanaz, de szerintem ez teljeskörűbb
    - egy konkrét topológia leírása is benne van (OSPF, BGP)


## topologia futtatása
    sudo clab deploy -t <topology_file.clab.yml>


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


## backup script használata
``` bash
# backup
./config-backup.sh backup <topologia_neve>
```
- a topológia neve pl.: `bgp/big/clab-bgp-multisite-network` mappában található `network-topology.clab.yml` fájl alapján készül --> name: `bgp-multisite-network`

``` bash
# restore
./config-backup.sh restore <topologia_neve>
```
- hasonolóan a backuphoz, csak restore-t írunk
- a restore parancs a `configs-backup/<topologia_neve>` mappában lévő fájlokat fogja visszaállítani a megfelelő helyre

**!!! FONTOS !!!**
---
a restore parancs csak akkor működik, ha a topológia már fut, és a docker containerek elérhetők!
ezután érdemes kiadni a `sudo clab redeploy -t <topology_file.clab.yml>` parancsot, hogy a containerlab újraindítsa a topológiát a frissített konfigurációval.


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
