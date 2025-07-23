# Multisite BGP Network Lab – Containerlab

Ez a labor egy három helyszínből (Budapest, New York, Tokió) álló nemzetközi hálózatot szimulál Arista cEOS routerek és Linux hostok segítségével, Containerlab környezetben. A helyszínek közötti kapcsolat BGP-vel van megvalósítva, privát IP-címekkel.

---

## Hálózati Topológia

- **Budapest**: `bud-r1`, `bud-r2`, `bud-r3` + `host-bud`
- **New York**: `ny-r1`, `ny-r2`, `ny-r3` + `host-ny`
- **Tokió**: `tok-r1`, `tok-r2`, `tok-r3` + `host-tok`

- Minden irodában 3 belső router + 1 host található.
- Belső kapcsolatok iBGP-vel, irodák között eBGP-vel működnek.
- Budapest adja az internet gateway szerepét.

---

## Használt technológiák

- **Containerlab**
- **Arista cEOS**
- **BGP (iBGP + eBGP)**
- **Privát IP-címzés (10.0.0.0/8)**

---

## IP-címzési terv (10.0.0.0/8)

### Globális szegmentálás

| Helyszín      | Tartomány       |
|---------------|-----------------|
| Budapest      | 10.1.0.0/16     |
| New York      | 10.2.0.0/16     |
| Tokió         | 10.3.0.0/16     |
| WAN linkek    | 10.100.0.0/16   |
| Loopback ID-k | 10.255.0.0/16   |

---

### Példák Budapest irodából

#### Lokális router kapcsolatok
---
#### Budapest

| Kapcsolat         | Hálózat      | Eszköz   | IP           |
|-------------------|--------------|----------|--------------|
| bud-r1 ↔ bud-r2   | 10.1.0.0/30  | bud-r1   | 10.1.0.1     |
|                   |              | bud-r2   | 10.1.0.2     |
| bud-r1 ↔ bud-r3   | 10.1.0.4/30  | bud-r1   | 10.1.0.5     |
|                   |              | bud-r3   | 10.1.0.6     |
| bud-r2 ↔ bud-r3   | 10.1.0.8/30  | bud-r2   | 10.1.0.9     |
|                   |              | bud-r3   | 10.1.0.10    |
| bud-r3 ↔ host-bud | 10.1.0.12/30 | bud-r3   | 10.1.0.13    |
|                   |              | host-bud | 10.1.0.14    |


#### New York

| Kapcsolat         | Hálózat      | Eszköz   | IP           |
|-------------------|--------------|----------|--------------|
| ny-r1 ↔ ny-r2     | 10.2.0.0/30  | ny-r1    | 10.2.0.1     |
|                   |              | ny-r2    | 10.2.0.2     |
| ny-r1 ↔ ny-r3     | 10.2.0.4/30  | ny-r1    | 10.2.0.5     |
|                   |              | ny-r3    | 10.2.0.6     |
| ny-r2 ↔ ny-r3     | 10.2.0.8/30  | ny-r2    | 10.2.0.9     |
|                   |              | ny-r3    | 10.2.0.10    |
| ny-r3 ↔ host-ny   | 10.2.0.12/30 | ny-r3    | 10.2.0.13    |
|                   |              | host-ny  | 10.2.0.14    |


#### Tokió

| Kapcsolat         | Hálózat      | Eszköz   | IP           |
|-------------------|--------------|----------|--------------|
| tok-r1 ↔ tok-r2   | 10.3.0.0/30  | tok-r1   | 10.3.0.1     |
|                   |              | tok-r2   | 10.3.0.2     |
| tok-r1 ↔ tok-r3   | 10.3.0.4/30  | tok-r1   | 10.3.0.5     |
|                   |              | tok-r3   | 10.3.0.6     |
| tok-r2 ↔ tok-r3   | 10.3.0.8/30  | tok-r2   | 10.3.0.9     |
|                   |              | tok-r3   | 10.3.0.10    |
| tok-r3 ↔ host-tok | 10.3.0.12/30 | tok-r3   | 10.3.0.13    |
|                   |              | host-tok | 10.3.0.14    |


### Példák WAN linkekre (eBGP)

| Kapcsolat        | Hálózat       | Eszköz     | IP           |
|------------------|---------------|------------|--------------|
| bud-r1 ↔ ny-r1   | 10.100.0.0/30 | bud-r1     | 10.100.0.1   |
|                  |               | ny-r1      | 10.100.0.2   |
| bud-r2 ↔ tok-r1  | 10.100.0.4/30 | bud-r2     | 10.100.0.5   |
|                  |               | tok-r1     | 10.100.0.6   |
| ny-r2 ↔ tok-r2   | 10.100.0.8/30 | ny-r2      | 10.100.0.9   |
|                  |               | tok-r2     | 10.100.0.10  |

---


## Host konfiguráció
1. ifconfig `<interface>` `<ip-address>` netmask `<netmask>`
2. route add default gw `<gateway-ip>`

## Routing összefoglaló

- **iBGP** az azonos irodán belüli routerek között
- **eBGP** az irodák közötti kapcsolatokhoz
- **Budapest** biztosít internet elérhetőséget az összes irodának
- **Loopback IP-k** használhatók BGP router ID-nek

---

## Tesztelés

A hostokból (`host-bud`, `host-ny`, `host-tok`) `ping`, `traceroute`, `curl` parancsokkal tesztelhetők az útvonalak és a végponti elérés.

## Források
- [Containerlab dokumentáció](https://containerlab.dev/)
- [Arista cEOS dokumentáció](https://www.arista.com/en/support)
- [BGP RFC 4271](https://tools.ietf.org/html/rfc4271)
- [My Journey and Experience with Containerlab](https://juliopdx.com/2021/12/10/my-journey-and-experience-with-containerlab/)
- [BGP iBGP Full Mesh Peering](https://notes.networklessons.com/bgp-ibgp-full-mesh-peering)
