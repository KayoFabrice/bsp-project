
---

# Embedded Sensor & Actuator Hub

## **Description**

Le projet **Embedded Sensor & Actuator Hub** est un projet pratique pour apprendre le **développement de drivers Linux** sur matériel embarqué (Raspberry Pi ou BeagleBone).
Il permet de :

* Lire des capteurs I2C et SPI
* Gérer des GPIO avec interruption
* Exposer les données via char device (`/dev/sensor_hub`), sysfs et mmap
* Implémenter des lectures périodiques avec timers/workqueues
* Optionnel : transfert de données via DMA, USB ou réseau

Ce projet couvre **toutes les notions essentielles du développement de drivers Linux**, depuis la création d’un module kernel jusqu’à l’application utilisateur complète.

---

## **Fonctionnalités**

* Character device pour communication kernel ↔ utilisateur
* Gestion des GPIO avec LED et bouton (interruption)
* Drivers I2C pour capteurs de température et pression
* Drivers SPI pour capteurs gyroscope/accéléromètre
* Exposition des paramètres et données via sysfs et procfs
* Accès direct au buffer via mmap
* Lecture périodique asynchrone via timers/workqueues
* Optionnel : transfert DMA pour accélération des lectures
* Optionnel : transmission USB ou réseau vers un PC
* Application utilisateur complète pour lire, configurer et visualiser les données

---

## **Matériel recommandé**

* Raspberry Pi ou BeagleBone
* Capteurs I2C : TMP102, BMP280
* Capteur SPI : MPU-9250
* LED et bouton GPIO
* Optionnel : périphérique USB ou adaptateur réseau

---

## **Structure du projet**

```
/sensor_hub
│
├── drivers/
│   ├── sensor_hub.c            # Character device minimal
│   ├── sensor_hub_gpio.c       # GPIO + ISR
│   ├── sensor_hub_i2c.c        # Driver I2C
│   ├── sensor_hub_spi.c        # Driver SPI
│   ├── sensor_hub_sysfs.c      # sysfs / procfs
│   ├── sensor_hub_mmap.c       # mmap
│   ├── sensor_hub_timer.c      # Timers / Workqueues
│   ├── sensor_hub_dma.c        # DMA (optionnel)
│   └── sensor_hub_usb.c        # USB / réseau (optionnel)
│
├── user_app/
│   └── sensor_hub_app.c        # Programme utilisateur (C ou Python)
│
├── Makefile
└── README.md
```

---

## **Installation**

1. Cloner le dépôt :

```bash
git clone https://github.com/<votre-repo>/sensor_hub.git
cd sensor_hub
```

2. Compiler le module kernel :

```bash
make
```

3. Charger le module :

```bash
sudo insmod drivers/sensor_hub.ko
```

4. Créer le device file si nécessaire :

```bash
sudo mknod /dev/sensor_hub c <major> 0
sudo chmod 666 /dev/sensor_hub
```

5. Vérifier les logs :

```bash
dmesg | tail
```

---

## **Utilisation**

* Lire/écrire dans le char device depuis un programme utilisateur :

```bash
./user_app/sensor_hub_app
```

* Accéder aux fichiers sysfs :

```bash
cat /sys/class/sensor_hub/temperature
echo 25 > /sys/class/sensor_hub/threshold
```

* Utiliser mmap pour lecture directe (via programme utilisateur)

---

## **Roadmap / Livrables**

| Étape | Livrable                                   |
| ----- | ------------------------------------------ |
| 1     | Character device minimal (`sensor_hub.ko`) |
| 2     | GPIO avec LED et bouton ISR                |
| 3     | Capteurs I2C (TMP102, BMP280)              |
| 4     | Capteurs SPI (MPU-9250)                    |
| 5     | sysfs / procfs                             |
| 6     | mmap                                       |
| 7     | Timers / Workqueues                        |
| 8     | DMA (optionnel)                            |
| 9     | USB / réseau (optionnel)                   |
| 10    | Programme utilisateur complet              |

---

## **Tests**

* Utiliser `dmesg` pour vérifier le fonctionnement du module
* Programmes tests pour chaque driver :

  * `test_char.c`, `test_gpio.c`, `test_i2c.c`, `test_spi.c`
* Vérifier lecture, écriture, mmap, timers et sysfs

---

