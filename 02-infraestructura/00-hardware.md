# Hardware — Especificaciones del Servidor

##  Intel NUC (Servidor Principal)

| Componente | Especificación |
|---|---|
| Procesador | Intel Core i5/i7 (12ª gen o superior) |
| RAM | 32 GB DDR4/DDR5 (mínimo 16 GB) |
| SSD | 512 GB NVMe (para SO y Docker) |
| Red | Gigabit Ethernet + WiFi |

##  DAS QNAP (Almacenamiento Masivo)

| Componente | Especificación |
|---|---|
| Capacidad | 4 TB (RAID 1 = 2 TB efectivos) |
| Interfaz | USB 3.0 o Thunderbolt |
| Punto de Montaje | `/mnt/TFG_CRIMSA/` |
| Velocidad | 100+ MB/s lectura/escritura |

##  Red

- **Router**: Con firewall activo
- **Tailscale**: VPN privada
- **Velocidad**: 100 Mbps mínimo
- **IP Tailscale**: 100.107.56.81 (ejemplo)

##  Requisitos Mínimos vs Recomendados

| Componente | Mínimo | Recomendado |
|---|---|---|
| CPU | Core i5 | Core i7 |
| RAM | 16 GB | 32 GB |
| SSD | 256 GB | 512 GB |
| DAS | 2 TB | 4 TB |
| Usuarios | 30 | 100+ |

