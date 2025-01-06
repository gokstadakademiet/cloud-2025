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


### **Oppgave 9: Volumer**

> [!IMPORTANT]  
> Volumer sikrer at dataene dine vedvares selv om kontaineren stoppes eller slettes.

Legg til et volum for å vedvare dataene i MySQL-databasen.

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
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
    ports: 
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      # - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h localhost -u root -pexample"]
      interval: 10s
      timeout: 5s
      retries: 3

volumes:
  mysql-data:
```

**Forklaring:**

1. **Volumer**: Vi legger til et volum for å vedvare dataene i MySQL-databasen. Volumer er en måte å lagre data utenfor kontainerens filsystem, slik at dataene ikke går tapt når kontaineren stoppes eller slettes.
2. **Oppdatere `docker-compose.yml`**: Vi oppdaterer `docker-compose.yml` filen til å inkludere volumet. Dette sikrer at dataene i MySQL-databasen vedvares mellom kontainerkjøringer.

</details>

<!-- ### **Oppgave 10: Skalerbarhet**

> [!TIP]  
> Skalerbarhet lar deg håndtere flere forespørsler ved å kjøre flere instanser av web-tjenesten.

Skaler web-tjenesten til å kjøre flere instanser.

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
        deploy:
            replicas: 3
            
    db:
        image: mysql:latest
        environment:
            MYSQL_ROOT_PASSWORD: example
        ports: 
            - "3306:3306"
        volumes:
            - mysql-data:/var/lib/mysql
        healthcheck:
            test: ["CMD-SHELL", "mysqladmin ping -h localhost -u root -pexample"]
            interval: 10s
            timeout: 5s
            retries: 3

volumes:
    mysql-data:
```

**Forklaring:**

1. **Skalerbarhet**: Vi bruker `deploy`-direktivet til å skalere web-tjenesten til å kjøre flere instanser. Skalerbarhet er evnen til å øke eller redusere antall kontainere som kjører en tjeneste basert på behov.
2. **Oppdatere `docker-compose.yml`**: Vi oppdaterer `docker-compose.yml` filen til å inkludere skalerbarhet. Dette gjør det mulig å håndtere flere forespørsler ved å kjøre flere instanser av web-tjenesten.

</details> -->

### **Oppgave 10: Helsekontroll**

> [!NOTE]  
> Helsekontroller brukes til å overvåke tilstanden til en kontainer og sikre at den kjører som forventet.

Legg til en helsekontroll for web-tjenesten.

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
        deploy:
            replicas: 3
        healthcheck:
            test: ["CMD", "curl", "-f", "http://localhost:8080"]
            interval: 30s
            timeout: 10s
            retries: 3
            
    db:
        image: mysql:latest
        environment:
            MYSQL_ROOT_PASSWORD: example
        ports: 
            - "3306:3306"
        volumes:
            - mysql-data:/var/lib/mysql
        healthcheck:
            test: ["CMD-SHELL", "mysqladmin ping -h localhost -u root -pexample"]
            interval: 10s
            timeout: 5s
            retries: 3

volumes:
    mysql-data:
```

**Forklaring:**

1. **Helsekontroll**: Vi legger til en helsekontroll for web-tjenesten ved hjelp av `healthcheck`-direktivet. Helsekontroller brukes til å overvåke tilstanden til en kontainer og sikre at den kjører som forventet.
2. **Oppdatere `docker-compose.yml`**: Vi oppdaterer `docker-compose.yml` filen til å inkludere helsekontrollen. Dette sikrer at tjenesten overvåkes og eventuelt restartes hvis den ikke fungerer som den skal.

</details>

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

<details><summary>Løsning</summary>

Feilen i konfigurasjonen ligger i at databasen ikke inneholder `messages`-tabellen ved oppstart. For å rette opp dette, kan vi legge til et skript som initialiserer databasen, samt legger inn en melding.

```javascript
// init-db.js
const mysql = require('mysql2');

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

        const createTableQuery = `
                CREATE TABLE IF NOT EXISTS messages (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        message VARCHAR(255) NOT NULL
                )
        `;

        connection.query(createTableQuery, (err, result) => {
                if (err) throw err;

                const insertMessageQuery = `
                        INSERT INTO messages (message)
                        VALUES ('Hello from MySQL')
                `;

                connection.query(insertMessageQuery, (err, result) => {
                        if (err) throw err;
                        console.log('Database initialized');
                        connection.end();
                });
        });
});
```

Oppdater `docker-compose.yml` til å kjøre initialiseringsskriptet før applikasjonen starter.

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
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8080/nonex || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
    depends_on: 
      db:
        condition: service_healthy
    command: ["sh", "-c", "node init-db.js && node app.js"]
    
      
  db:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
    ports: 
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      # - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h localhost -u root -pexample"]
      interval: 10s
      timeout: 5s
      retries: 3

volumes:
  mysql-data:
```

Nå vil databasen bli initialisert med en melding før applikasjonen starter, og applikasjonen vil kunne returnere meldingen fra databasen.

**Forklaring:**

1. **Feilsøking**: Identifiser og rett opp feilen i konfigurasjonen. Feilsøking er en viktig ferdighet for å identifisere og rette opp feil i applikasjoner.
2. **Oppdatere applikasjonen**: Sørg for at applikasjonen kjører riktig ved å rette opp feilen i konfigurasjonen.


</details>



### **Oppgave 12: Pushe Docker Image til Docker Hub**

> [!TIP]  
> Å pushe Docker images til Docker Hub gjør det enkelt å dele og distribuere applikasjonene dine.

I denne oppgaven skal vi pushe Docker imaget for web-containeren til Docker Hub.

<details><summary>Løsning</summary>

**Steg 1: Registrer en bruker på Docker Hub**

1. Gå til [Docker Hub](https://hub.docker.com/) og registrer en ny bruker hvis du ikke allerede har en konto.
2. Bekreft e-postadressen din og logg inn på Docker Hub.

**Steg 2: Logg inn på Docker Hub fra kommandolinjen**

1. Åpne terminalen.
2. Kjør kommandoen `docker login` og følg instruksjonene for å logge inn med Docker Hub-brukeren din.

```sh
docker login
```

**Steg 3: Bygg Docker imaget**

1. Naviger til katalogen som inneholder `Dockerfile` for web-tjenesten.
2. Bygg Docker imaget ved å kjøre følgende kommando:

```sh
docker build -t brukernavn/web-app:latest .
```

> Erstatt `brukernavn` med ditt Docker Hub-brukernavn.

**Steg 4: Pushe Docker imaget til Docker Hub**

1. Kjør følgende kommando for å pushe imaget til Docker Hub:

```sh
docker push brukernavn/web-app:latest
```

> Erstatt `brukernavn` med ditt Docker Hub-brukernavn.

**Forklaring:**

1. **Registrering og pålogging**: Først registrerer vi en bruker på Docker Hub og logger inn fra kommandolinjen. Dette er nødvendig for å autentisere og autorisere push-operasjonen.
2. **Bygging av image**: Vi bygger Docker imaget ved hjelp av `docker build`-kommandoen. `-t` flagget brukes til å tagge imaget med et navn og en versjon (i dette tilfellet `latest`).
3. **Pushing av image**: Vi pusher Docker imaget til Docker Hub ved hjelp av `docker push`-kommandoen. Dette laster opp imaget til Docker Hub, slik at det kan deles og distribueres.

</details>

### **Oppgave 13: Pulle Docker Image fra Docker Hub**

> [!TIP]  
> Å pulle Docker images fra Docker Hub gjør det enkelt å sette opp applikasjoner uten å måtte bygge dem lokalt.

I denne oppgaven skal vi pulle Docker imaget for web-containeren fra Docker Hub og bruke det i en `docker-compose`-fil.

<details><summary>Løsning</summary>

**Steg 1: Logg inn på Docker Hub fra kommandolinjen**

1. Åpne terminalen.
2. Kjør kommandoen `docker login` og følg instruksjonene for å logge inn med Docker Hub-brukeren din.

```sh
docker login
```

**Steg 2: Pulled Docker imaget**

1. Kjør følgende kommando for å pulle imaget fra Docker Hub:

```sh
docker pull brukernavn/web-app:latest
```

> Erstatt `brukernavn` med ditt Docker Hub-brukernavn.

**Steg 3: Oppdater `docker-compose.yml`**

1. Åpne `docker-compose.yml`-filen.
2. Endre `build: .` til `image: brukernavn/web-app:latest` under `web`-tjenesten.

```yaml
version: '3'
services:
  web: 
    image: brukernavn/web-app:latest
    ports:
      - "8080:8080"
    environment:
      MYSQL_HOST: db
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_DATABASE: exampledb
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8080/nonex || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
    command: ["sh", "-c", "node init-db.js && node app.js"]
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
    volumes:
      - mysql-data:/var/lib/mysql
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h localhost -u root -pexample"]
      interval: 10s
      timeout: 5s
      retries: 3

volumes:
  mysql-data:
```

**Forklaring:**

1. **Pålogging**: Vi logger inn på Docker Hub fra kommandolinjen for å autentisere og autorisere pull-operasjonen.
2. **Pulle image**: Vi pulle Docker imaget ved hjelp av `docker pull`-kommandoen. Dette laster ned imaget fra Docker Hub til din lokale maskin.
3. **Oppdatere `docker-compose.yml`**: Vi oppdaterer `docker-compose.yml`-filen for å bruke det pulled imaget i stedet for å bygge det lokalt. Dette gjør at `docker-compose` bruker det nedlastede imaget når den starter opp tjenestene.

</details>


