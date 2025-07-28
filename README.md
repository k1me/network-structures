# Hasznos információk

## Clab telepítése:

- [így](https://containerlab.dev/install/) 
  - containerlab oldala
- [vagy így](https://juliopdx.com/2021/12/10/my-journey-and-experience-with-containerlab/) 
    - másik oldal, de több infóval, pl. docker image-ekről 
    - alapvetően ugyanaz, de szerintem ez teljeskörűbb
    - egy konkrét topológia leírása is benne van (OSPF, BGP)


## Topologia futtatása
``` bash
sudo clab deploy -t <topology_file.clab.yml>
```

## Topologia leállítása
``` bash
sudo clab destroy -t <topology_file.clab.yml>
```

## Topologia újraindítása
``` bash
sudo clab redeploy -t <topology_file.clab.yml>
```

## Docker containerek listázása:
``` bash
# futó containerek listázása
sudo docker ps 

# összes container listázása (futó és leállítottak is)
sudo docker ps -a 
```
## Docker containerek törlése:
Van olyan eset, amikor nem valamilyen okból kifolyólag (pl. elfogy a RAM, nem válaszol a container, stb...) nem tudjuk leállítani a containert, ilyenkor erőltetett törlést kell alkalmazni sajnos (legalább is nem találtam ettől jobb megoldást a problémára).
``` bash
# erőltetett törlése a containereknek
sudo docker rm -f $(sudo docker ps -aq)
```

## Clab hostok ip-konfigurációja:
``` bash
ifconfig <eth_port> <ip_address> netmask <netmask> up
route add default gw <gateway_ip>
```

## Backup script használata
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
1. a restore parancs csak akkor működik, ha a topológia már fut, és a docker containerek elérhetők!
ezután érdemes kiadni a `sudo clab redeploy -t <topology_file.clab.yml>` parancsot, hogy a containerlab újraindítsa a topológiát a frissített konfigurációval.
2. a backup parancs csak akkor működik, ha a topológia már fut, és a docker containerek elérhetők!
3. a `network-topology.clab.yml` fájlban a `name` mezőben megadott név alapján fogja a script a backup mappát létrehozni, illetve a restore parancs is ezt a nevet használja a visszaállításhoz.
4. a `network-topology.clab.yml` fájlban az eszközök képei meg kell, hogy egyezzenek a Dockerhez hozzáadott image-tagekkel, pl. `arista_ceos:4.28.13M`
5. ha nem ugyan azt a verziójú image-t töltöttük le, tapasztalat alaján, nem fog számítani, annyi, hogy vagy a `network-topology.clab.yml` fájlban írjuk át a dockerben lévő image verziójára vagy a dockerben lévő taget cseréljük le

## Tag csere docker image-en:
``` bash
sudo docker tag <image_tag:verzio> <new_image_name:verzio>

# ha már nincs rá szükség
sudo docker rmi <image_tag:verzio> 

# docker image ellenőrzése
sudo docker images
```


## Mappastruktúra

```bash
.
├── bgp/
    ├── big/                                # "bonyolultabb" topológiák
        ├── clab-bgp-multisite-network      # feladat directory
            ├── ...
            ├── network-topology.clab.yml   # feladat topológiája
            ├── README.md                   # dokumentáció 
    ├── small/                              # egyszerűbb topológiák
        └── ...
    └── ...
├── configs-backup/                         # backup directory
    ├──bgp-multisite-network
       ├── bud-r1
       ├── bud-r2
       └── ...
    └── ...
├── config-backup.sh                        # backup/restore script
├── diagrams/                               # topológiákhoz tartozó diagramok
    ├── bgp
        └── topology.png
    └── ...
└── README.md                              # jegyzetek, információk
```
