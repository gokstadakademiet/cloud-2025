# Oppgavesett: Docker og docker-compose
# Innholdsfortegnelse 

1. [Opprette en enkel Docker-kontainer](#oppgave-1-opprette-en-enkel-docker-kontainer)
2. [Bygge og kjøre Docker-kontaineren](#oppgave-2-bygge-og-kjøre-docker-kontaineren)
3. [Bruke Docker Compose](#oppgave-3-bruke-docker-compose)
4. [Kjør applikasjonen med Docker Compose](#oppgave-4-kjør-applikasjonen-med-docker-compose)
5. [Legge til en database](#oppgave-5-legge-til-en-database)
6. [Logge inn i databasen og verifiser at brukeren exampleuser er opprettet](#oppgave-6-logge-inn-i-databasen-og-verifiser-at-brukeren-exampleuser-er-opprettet)
7. [Koble applikasjonen til databasen](#oppgave-7-koble-applikasjonen-til-databasen)
8. [Miljøvariabler](#oppgave-8-miljøvariabler)
9. [Volumer](#oppgave-9-volumer)
10. [Helsekontroll](#oppgave-10-helsekontroll)
11. [Feilsøking](#oppgave-11-feilsøking)
12. [Pushe Docker Image til Docker Hub](#oppgave-12-pushe-docker-image-til-docker-hub)
13. [Pulle Docker Image fra Docker Hub](#oppgave-13-pulle-docker-image-fra-docker-hub)


## Introduksjon til Docker

### Før du starter

For å komme i gang med Docker, må du først installere noen nødvendige verktøy. Sørg for at du har følgende installert på maskinen din før du starter:

1. **Docker Desktop**: Dette er en applikasjon som gjør det enkelt å bygge, kjøre og dele applikasjoner med Docker. Du kan laste ned og installere Docker Desktop fra [Docker sin offisielle nettside](https://www.docker.com/products/docker-desktop).

2. **Docker Compose**: Dette verktøyet følger vanligvis med Docker Desktop, men du kan også installere det separat hvis nødvendig. Docker Compose lar deg definere og kjøre multi-kontainer Docker-applikasjoner ved hjelp av en YAML-fil. Følg instruksjonene på [Docker Compose sin offisielle nettside](https://docs.docker.com/compose/install/) for å installere det.

3. **Visual Studio Code**: Dette er en populær kodeditor som støtter en rekke utvidelser for å jobbe med Docker. Du kan laste ned og installere Visual Studio Code fra [Visual Studio Code sin offisielle nettside](https://code.visualstudio.com/).

Visual Studio Code skiller seg fra Visual Studio ved å være lettere og mer fleksibel. Mens Visual Studio er en fullverdig integrert utviklingsmiljø (IDE) som er spesielt godt egnet for store prosjekter og enterprise-utvikling i .NET, er Visual Studio Code en kodeditor som er raskere å starte opp og enklere å tilpasse med extensions. Dette gjør Visual Studio Code ideell for cloud-utvikling, hvor man ofte jobber med containere, mikrotjenester og andre moderne utviklingsmetoder som krever en smidig og tilpasningsdyktig arbeidsflyt.

### Gode extensions i Visual Studio Code
For en god kodeopplevelse, bør du installere nødvendige extensions i Visual Studio Code:
1. **Docker Extension**: Gir støtte for å bygge, administrere og kjøre containere direkte fra VS Code. https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker
2. **YAML Extension**: For bedre støtte og autokomplettering når du jobber med YAML-filer. https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml

Når du har installert disse verktøyene og extensions, er du klar til å begynne å jobbe med Docker og følge oppgavene i denne veiledningen.

### Hvordan koble til database med MySQL Workbench?

Følg guiden [her](https://medium.com/@victoria.kruczek_15509/create-a-local-database-with-docker-compose-and-view-it-in-mysql-workbench-974aee047874) som viser hvordan en kobler seg til databasen med MySQL Workbench. 

### Eksempel på prosjektstruktur med `docker-compose` og flere ulike prosjekter


Dette kan være en typisk prosjektstruktur når man jobber med `docker-compose`. Strukturen viser hvordan man kan organisere filer og kataloger for en applikasjon som består av flere tjenester, som en API-tjeneste, en web-tjeneste og en database. Hver tjeneste har sin egen Dockerfile og nødvendige konfigurasjonsfiler. `docker-compose.yml` filen brukes til å definere og administrere disse tjenestene.

```
project-root/
├── docker-compose.yml
├── api/
│   ├── Dockerfile
│   ├── Program.cs
│   ├── Startup.cs
│   ├── api.csproj
│   └── ...
├── web/
│   ├── Dockerfile
│   ├── Program.cs
│   ├── Startup.cs
│   ├── web.csproj
│   └── ...
├── db/
│   └── init.sql
└── README.md
```

```yaml
# docker-compose.yml
version: '3.8'
 
services:
  api:
    build:
      context: ./api
      dockerfile: Dockerfile
    ports:
      - "5000:80"
    depends_on:
      db:
        condition: service_healthy
 
  web:
    build:
      context: ./web
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    depends_on:
      api:
        condition: service_healthy
 
  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
    ports:
      - "3306:3306"
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h localhost -u root -pexample"]
      interval: 10s
      timeout: 5s
      retries: 3
```

> [!TIP]  
> Trykk på dropdownen under for å se dokument