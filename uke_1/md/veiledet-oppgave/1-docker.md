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

<details><summary>Løsning</summary>

```dockerfile
# Bruk et offisielt Docker-bilde for Node.js
FROM node:20

# Opprett en arbeidskatalog
WORKDIR /usr/src/app

# Kopier package.json og package-lock.json
COPY package*.json ./

# Installer avhengigheter
RUN npm install

# Kopier resten av applikasjonen
COPY . .

# Eksponer porten applikasjonen kjører på
EXPOSE 8080

# Start applikasjonen
CMD ["node", "app.js"]
```

**Forklaring:**

1. **Dockerfile**: Dette er en fil som inneholder instruksjoner for å bygge Docker-bildet. Hver instruksjon i Dockerfile utfører en handling, som å sette opp et miljø, kopiere filer, eller kjøre kommandoer.
2. **Node.js-applikasjon**: En enkel Node.js-applikasjon som returnerer "Hello World" når den blir besøkt. Node.js er en JavaScript-runtime som lar deg kjøre JavaScript på serversiden.

</details>

### **Oppgave 2: Bygge og kjøre Docker-kontaineren**

> [!NOTE]  
> Sørg for at du er i samme katalog som Dockerfile når du kjører kommandoene nedenfor.

Bygg Docker-bildet fra Dockerfile og kjør kontaineren. 

<details><summary>Løsning</summary>

```bash
# Bygg Docker-bildet
docker build -t hello-world-app .

# Kjør Docker-kontaineren
docker run -p 8080:8080 hello-world-app
```

**Forklaring:**

1. **Bygge bildet**: `docker build` kommandoen bygger et Docker-bilde fra Dockerfile. Et Docker-bilde er en lesbar mal som inneholder alt som trengs for å kjøre en applikasjon.
2. **Kjøre kontaineren**: `docker run` kommandoen kjører kontaineren og binder port 8080 på vertsmaskinen til port 8080 i kontaineren. En Docker-kontainer er en kjørbar instans av et Docker-bilde.

</details>

### **Oppgave 3: Bruke Docker Compose**

> [!TIP]  
> Docker Compose gjør det enklere å administrere multi-kontainer applikasjoner ved å bruke en enkel YAML-fil.

Lag en `docker-compose.yml` fil for å kjøre applikasjonen fra forrige oppgave.

<details><summary>Løsning</summary>

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "8080:8080"
```

**Forklaring:**

1. **Docker Compose**: Dette er et verktøy for å definere og kjøre multi-kontainer Docker-applikasjoner. Det lar deg bruke en YAML-fil for å konfigurere applikasjonens tjenester.
2. **docker-compose.yml**: En fil som definerer tjenestene som utgjør applikasjonen din. I dette tilfellet definerer vi en tjeneste kalt `web` som bygger fra den nåværende katalogen og eksponerer port 8080.

</details>

### **Oppgave 4: Kjør applikasjonen med Docker Compose**

> [!IMPORTANT]  
> Sørg for at Docker Compose er installert på systemet ditt før du kjører kommandoen nedenfor.

Kjør applikasjonen ved hjelp av Docker Compose.

<details><summary>Løsning</summary>

```bash
# Kjør Docker Compose
docker-compose up
```

**Forklaring:**

1. **docker-compose up**: Denne kommandoen bygger, (re)skaper, starter og knytter sammen tjenestene som er definert i `docker-compose.yml` filen. Dette gjør det enkelt å administrere og kjøre multi-kontainer applikasjoner.

</details>

### **Oppgave 5: Legge til en database**

> [!CAUTION]  
> Sørg for at du har nok ressurser på maskinen din til å kjøre både web-tjenesten og databasen.

Utvid `docker-compose.yml` filen til å inkludere en MySQL-database. Husk å legge til en helsesjekk for å være sikker på at databasen har startet før webserveren spinnes opp.

<details><summary>Løsning</summary>

```yaml
version: '3'
services:
  web: 
    build: .
    ports:
      - "8080:8080"
    depends_on: 
      db:
        condition: service_healthy
  db:
    image: mysql:latest
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

**Forklaring:**

1. **Legge til en database**: Vi legger til en MySQL-tjeneste i `docker-compose.yml` filen. MySQL er en populær relasjonsdatabase.
2. **depends_on med helsesjekk**: Vi bruker `depends_on` med `condition: service_healthy` for å sikre at web-tjenesten kun starter når MySQL-tjenesten er sunn. Dette er viktig for å sikre at databasen er tilgjengelig når web-applikasjonen prøver å koble til den.
3. **Helsesjekk**: Vi legger til en `healthcheck` for MySQL-tjenesten som bruker `mysqladmin ping` for å sjekke om databasen er oppe og kjører. Dette sikrer at web-tjenesten ikke starter før databasen er klar.
4. **Automatisk opprettelse av bruker**: Når miljøvariablene `MYSQL_DATABASE`, `MYSQL_USER`, og `MYSQL_PASSWORD` er satt, vil MySQL automatisk opprette databasen og brukeren med de spesifiserte verdiene. Dette gjør det enkelt å sette opp en ny database med en bruker uten ekstra konfigurasjon.

</details>


### **Oppgave 6: Logge inn i databasen og verifiser at brukeren `exampleuser` er opprettet**

> [!TIP]  
> Bruk MySQL-klienten til å logge inn i databasen som rot-brukeren og kjøre `SHOW DATABASES`.

Logg inn i MySQL-databasen som rot-brukeren og kjør kommandoen `SHOW DATABASES` for å vise alle tilgjengelige databaser. Verifiser også at brukeren `exampleuser` eksisterer i databasen.

<details><summary>Løsning</summary>

```bash
# Åpne en shell-session i databasekontaineren
docker exec -it <db_container_name> /bin/sh

# Logg inn i MySQL-databasen som rot-brukeren
mysql -u root -pexample

# Kjør kommandoen for å vise alle databaser
SHOW DATABASES;

# Verifiser at brukeren 'exampleuser' eksisterer
SELECT User FROM mysql.user;
```

**Forklaring:**

1. **Åpne en shell-session**: Vi bruker `docker exec` kommandoen for å åpne en shell-session inne i databasekontaineren. Dette lar oss kjøre kommandoer direkte i kontaineren.
2. **Logge inn i databasen**: Når vi er inne i kontaineren, bruker vi MySQL-klienten til å logge inn i databasen som rot-brukeren.
3. **Kjøre `SHOW DATABASES`**: Når vi er logget inn, kjører vi `SHOW DATABASES` kommandoen for å vise alle tilgjengelige databaser. Dette er nyttig for å verifisere at databasen er riktig konfigurert og kjører som forventet.
4. **Verifisere brukeren**: Vi kjører en SQL-forespørsel for å sjekke at brukeren `exampleuser` eksisterer i databasen. Dette sikrer at brukeren er opprettet og kan brukes til å koble til databasen.

</details>


### **Oppgave 7: Koble applikasjonen til databasen**

> [!NOTE]  
> Sørg for at MySQL-tjenesten kjører før du prøver å koble til databasen fra applikasjonen.

Oppdater Node.js-applikasjonen til å koble til MySQL-databasen.

<details><summary>Løsning</summary>

```javascript
// app.js
const http = require('http');
const mysql = require('mysql2');

const hostname = '0.0.0.0';
const port = 8080;
const dbConfig = {
  host: 'db',
  user: 'exampleuser',
  password: 'examplepass',
  database: 'exampledb',
  port: 3306,
};

const connection = mysql.createConnection(dbConfig);

connection.connect((err) => {
  if (err) {
    console.error('Failed to connect to database', err);
    throw err;
  }

  console.log(`Connected to database ${dbConfig.database}`);

  const server = http.createServer((req, res) => {
    if (req.url === '/') {
      res.statusCode = 200;
      res.setHeader('Content-Type', 'application/json');
      res.end('Hello world');
    }
  
    else {
      res.statusCode = 404;
      res.setHeader('Content-Type', 'text/plain');
      res.end('Not found');
    }
  });

  server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
  });
});
```

**Forklaring:**

1. **Koble til MySQL**: Vi bruker MySQL-klienten til å koble til databasen. MySQL-klienten er en del av MySQL Node.js-driveren som lar oss kommunisere med MySQL fra en Node.js-applikasjon.
2. **Oppdatere applikasjonen**: Vi oppdaterer applikasjonen til å koble til databasen før den starter HTTP-serveren. Dette sikrer at applikasjonen kan kommunisere med databasen når den mottar forespørsler.

</details>

### **Oppgave 8: Miljøvariabler**

> [!TIP]  
> Bruk av miljøvariabler gjør applikasjonen mer fleksibel og enklere å konfigurere i forskjellige miljøer.

Bruk miljøvariabler for å konfigurere databaseforbindelsen.

<details><summary>Løsning</summary>

```yaml
version: '3'
services:
  web: 
    build: .
    ports:
      - "8080:8080"
    environment:
      MYSQL_HOST: db
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_DATABASE: exampledb
    depends_on: 
      db:
        condition: service_healthy
      
  db:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: example
      # MYSQL_DATABASE: exampledb
      # MYSQL_USER: exampleuser
      # MYSQL_PASSWORD: examplepass
    ports: 
      - "3306:3306"
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h localhost -u root -pexample"]
      interval: 10s
      timeout: 5s
      retries: 3
```

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
  if (err) {
    console.error('Failed to connect to database', err);
    throw err;
  }

  console.log(`Connected to database ${dbConfig.database}`);

  const server = http.createServer((req, res) => {
    if (req.url === '/') {
      res.statusCode = 200;
      res.setHeader('Content-Type', 'application/json');
      res.end('Hello world');
    }
  
    else {
      res.statusCode = 404;
      res.setHeader('Content-Type', 'text/plain');
      res.end('Not found');
    }
  });

  server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
  });
});
```

**Forklaring:**

1. **Miljøvariabler**: Vi bruker miljøvariabler for å konfigurere databaseforbindelsen. Miljøvariabler er en måte å konfigurere applikasjoner på uten å hardkode verdier i kildekoden.
2. **Oppdatere applikasjonen**: Vi oppdaterer applikasjonen til å bruke miljøvariablene. Dette gjør applikasjonen mer fleksibel og enklere å konfigurere i forskjellige miljøer.

</details>