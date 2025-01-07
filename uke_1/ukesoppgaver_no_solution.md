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
> Trykk på dropdownen under for å se dokumentasjon om portene som er valgt i `docker.compose.yml`-filen over.

<details><summary>Dokumentasjon for docker-compose.yml</summary>

### Valg av porter

I denne `docker-compose.yml`-filen har vi valgt å mappe forskjellige porter på vertsmaskinen til port 80 på containerne. Her er en forklaring på hvorfor vi har gjort disse valgene:

#### API-tjenesten
- **Vertsmaskinens port 5000 til containerens port 80**:
  - Vi har valgt å mappe port 5000 på vertsmaskinen til port 80 på API-containeren. Dette gjør det enkelt å få tilgang til API-tjenesten via vertsmaskinens port 5000, samtidig som vi holder standard HTTP-porten (80) inne i containeren. Dette er nyttig for å unngå portkonflikter på vertsmaskinen og for å kunne kjøre flere tjenester samtidig.

#### Web-tjenesten
- **Vertsmaskinens port 8080 til containerens port 80**:
  - Web-tjenesten er mappet fra port 8080 på vertsmaskinen til port 80 på containeren. Dette følger samme prinsipp som for API-tjenesten, hvor vi bruker en annen port på vertsmaskinen (8080) for å unngå konflikter og samtidig holde standard HTTP-porten (80) inne i containeren. Dette gjør det enkelt å få tilgang til web-applikasjonen via vertsmaskinens port 8080.

#### Database-tjenesten
- **Vertsmaskinens port 3306 til containerens port 3306**:
  - For database-tjenesten har vi valgt å mappe port 3306 på vertsmaskinen direkte til port 3306 på containeren. Dette er fordi 3306 er standardporten for MySQL-databaser, og det er praktisk å bruke samme port både på vertsmaskinen og inne i containeren for enkel tilgang og administrasjon.

Ved å bruke forskjellige porter på vertsmaskinen for API- og web-tjenestene, kan vi kjøre begge tjenestene samtidig uten portkonflikter. Samtidig holder vi standard HTTP-porten (80) inne i containerne for konsistens og enkelhet.

</details>


-------

### **Oppgave 1: Opprette en enkel Docker-kontainer**

> [!IMPORTANT]  
> Sørg for at du har Docker installert på maskinen din før du starter denne oppgaven.

Lag en enkel Docker-kontainer som kjører en "Hello World"-applikasjon. Bruk et offisielt Docker-bilde for å gjøre dette. Du kan bruke følgende Node-kode for "Hello World"-applikasjonen:

```javascript
// app.js
const http = require('http');

const hostname = '0.0.0.0';
const port = 8080;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
```


### **Oppgave 2: Bygge og kjøre Docker-kontaineren**

> [!NOTE]  
> Sørg for at du er i samme katalog som Dockerfile når du kjører kommandoene nedenfor.

Bygg Docker-bildet fra Dockerfile og kjør kontaineren. 


### **Oppgave 3: Bruke Docker Compose**

> [!TIP]  
> Docker Compose gjør det enklere å administrere multi-kontainer applikasjoner ved å bruke en enkel YAML-fil.

Lag en `docker-compose.yml` fil for å kjøre applikasjonen fra forrige oppgave.


### **Oppgave 4: Kjør applikasjonen med Docker Compose**

> [!IMPORTANT]  
> Sørg for at Docker Compose er installert på systemet ditt før du kjører kommandoen nedenfor.

Kjør applikasjonen ved hjelp av Docker Compose.


### **Oppgave 5: Legge til en database**

> [!CAUTION]  
> Sørg for at du har nok ressurser på maskinen din til å kjøre både web-tjenesten og databasen.

Utvid `docker-compose.yml` filen til å inkludere en MySQL-database. Husk å legge til en helsesjekk for å være sikker på at databasen har startet før webserveren spinnes opp.



### **Oppgave 6: Logge inn i databasen og verifiser at brukeren `exampleuser` er opprettet**

> [!TIP]  
> Bruk MySQL-klienten til å logge inn i databasen som rot-brukeren og kjøre `SHOW DATABASES`.

Logg inn i MySQL-databasen som rot-brukeren og kjør kommandoen `SHOW DATABASES` for å vise alle tilgjengelige databaser. Verifiser også at brukeren `exampleuser` eksisterer i databasen.



### **Oppgave 7: Koble applikasjonen til databasen**

> [!NOTE]  
> Sørg for at MySQL-tjenesten kjører før du prøver å koble til databasen fra applikasjonen.

Oppdater Node.js-applikasjonen til å koble til MySQL-databasen.


### **Oppgave 8: Miljøvariabler**

> [!TIP]  
> Bruk av miljøvariabler gjør applikasjonen mer fleksibel og enklere å konfigurere i forskjellige miljøer.

Bruk miljøvariabler for å konfigurere databaseforbindelsen.



### **Oppgave 9: Volumer**

> [!IMPORTANT]  
> Volumer sikrer at dataene dine vedvares selv om kontaineren stoppes eller slettes.

Legg til et volum for å vedvare dataene i MySQL-databasen.


<!-- ### **Oppgave 10: Skalerbarhet**

> [!TIP]  
> Skalerbarhet lar deg håndtere flere forespørsler ved å kjøre flere instanser av web-tjenesten.

Skaler web-tjenesten til å kjøre flere instanser.


### **Oppgave 10: Helsekontroll**

> [!NOTE]  
> Helsekontroller brukes til å overvåke tilstanden til en kontainer og sikre at den kjører som forventet.

Legg til en helsekontroll for web-tjenesten.


### **Oppgave 11: Feilsøking**

> [!IMPORTANT]  
> Feilsøking er en viktig ferdighet for å identifisere og rette opp feil i applikasjoner.

I denne oppgaven skal du finne og rette en feil i en Docker-konfigurasjon. Koden nedenfor er ment å sette opp en enkel Node.js-applikasjon som kobler til en MySQL-database og returnerer en melding fra databasen. Men det er en feil i konfigurasjonen som forhindrer applikasjonen fra å kjøre riktig.

```javascript
// app.js
const http = require('http');
const mysql = require('mysql2');

const hostname = '0.0.0.0';
const port = 8080;
const dbConfig = {
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
  port: 3306
};

const connection = mysql.createConnection(dbConfig);

connection.connect((err) => {
        if (err) throw err;
        console.log('Connected to database');

        const server = http.createServer((req, res) => {
                connection.query('SELECT message FROM messages LIMIT 1', (err, result) => {
                        if (err) throw err;

                        res.statusCode = 200;
                        res.setHeader('Content-Type', 'text/plain');
                        res.end(result[0].message);
                });
        });

        server.listen(port, hostname, () => {
                console.log(`Server running at http://${hostname}:${port}/`);
        });
});
```




### **Oppgave 12: Pushe Docker Image til Docker Hub**

> [!TIP]  
> Å pushe Docker images til Docker Hub gjør det enkelt å dele og distribuere applikasjonene dine.

I denne oppgaven skal vi pushe Docker imaget for web-containeren til Docker Hub.


### **Oppgave 13: Pulle Docker Image fra Docker Hub**

> [!TIP]  
> Å pulle Docker images fra Docker Hub gjør det enkelt å sette opp applikasjoner uten å måtte bygge dem lokalt.

I denne oppgaven skal vi pulle Docker imaget for web-containeren fra Docker Hub og bruke det i en `docker-compose`-fil.



