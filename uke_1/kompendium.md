# Uke 1: Docker og Docker Compose

1. [Introduksjon til Docker](#1-introduksjon-til-docker)
  - [Hva er Docker?](#hva-er-docker)
  - [Fordeler med Docker](#fordeler-med-docker)
  - [Installere Docker](#installere-docker)
  - [Grunnleggende Docker-kommandoer](#grunnleggende-docker-kommandoer)
2. [Docker Images og Containers](#2-docker-images-og-containers)
  - [Hva er et Docker Image?](#hva-er-et-docker-image)
  - [Bygge et Docker Image](#bygge-et-docker-image)
  - [Hva er en Docker Container?](#hva-er-en-docker-container)
  - [Kjøre en Docker Container](#kjøre-en-docker-container)
3. [Docker Compose](#3-docker-compose)
  - [Hva er Docker Compose?](#hva-er-docker-compose)
  - [Installere Docker Compose](#installere-docker-compose)
  - [Grunnleggende Docker Compose-kommandoer](#grunnleggende-docker-compose-kommandoer)
  - [Opprette en `docker-compose.yml`-fil](#opprette-en-docker-composeyml-fil)

# **1. Introduksjon til Docker**

## Hva er Docker?

Docker er en plattform for å utvikle, sende og kjøre applikasjoner i containere. Containere er lette, bærbare og sikre kjøremiljøer som inneholder alt som trengs for å kjøre en applikasjon.

## Fordeler med Docker

- **Portabilitet:** Docker-containere kan kjøre på hvilken som helst maskin som har Docker installert.
- **Isolasjon:** Hver container kjører isolert fra andre containere og vertssystemet.
- **Effektivitet:** Docker bruker systemressurser mer effektivt enn tradisjonelle virtuelle maskiner.

## Installere Docker

For å installere Docker, følg instruksjonene på [Docker sin offisielle nettside](https://docs.docker.com/get-docker/).

## Grunnleggende Docker-kommandoer

- `docker run`: Kjører en ny container.
- `docker ps`: Viser kjørende containere.
- `docker stop`: Stopper en kjørende container.
- `docker build`: Bygger et Docker image fra en Dockerfile.

# **2. Docker Images og Containers**

## Hva er et Docker Image?

Et Docker image er en read-only mal som inneholder en applikasjon og alle dens avhengigheter. Images brukes til å opprette Docker-containere.

## Bygge et Docker Image

> [!TIP]
> Bruk en beskrivende tag for ditt Docker image for enklere identifikasjon senere.

For å bygge et Docker image, opprett en `Dockerfile` og kjør kommandoen:
```bash
docker build -t my-image .
```

## Hva er en Docker Container?

En Docker container er en kjørbar instans av et Docker image. Containere er isolerte miljøer som kjører applikasjoner.

## Kjøre en Docker Container

> [!CAUTION]
> Sørg for at portene du eksponerer ikke er i konflikt med andre tjenester som kjører på vertsmaskinen.

For å kjøre en container fra et image, bruk kommandoen:
```bash
docker run -d --name my-container my-image
```

# **3. Docker Compose**

## Hva er Docker Compose?

Docker Compose er et verktøy for å definere og kjøre multi-container Docker-applikasjoner. Med Docker Compose kan du bruke en YAML-fil til å konfigurere applikasjonens tjenester.

## Installere Docker Compose

> [!IMPORTANT]
> Docker Compose er inkludert i Docker Desktop for Windows og Mac. For Linux, følg instruksjonene på [Docker Compose sin offisielle nettside](https://docs.docker.com/compose/install/).

Docker Compose er inkludert i Docker Desktop for Windows og Mac. For Linux, følg instruksjonene på [Docker Compose sin offisielle nettside](https://docs.docker.com/compose/install/).

## Grunnleggende Docker Compose-kommandoer

> [!TIP]
> Bruk `docker-compose up -d` for å starte tjenestene i bakgrunnen.

- `docker-compose up`: Starter alle tjenestene definert i `docker-compose.yml`.
- `docker-compose down`: Stopper og fjerner alle tjenestene.
- `docker-compose build`: Bygger eller gjenoppbygger tjenestene.

## Opprette en `docker-compose.yml`-fil

En enkel `docker-compose.yml`-fil kan se slik ut:
```yaml
version: '3'
services:
  web:
  image: nginx
  ports:
    - "80:80"
  db:
  image: postgres
  environment:
    POSTGRES_PASSWORD: example
```

Denne filen definerer to tjenester: en `web`-tjeneste som kjører Nginx og en `db`-tjeneste som kjører PostgreSQL.

**Kilder:**

- [Offisiell Docker Dokumentasjon](https://docs.docker.com/)
- [Offisiell Docker Compose Dokumentasjon](https://docs.docker.com/compose/)