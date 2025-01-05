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
FROM node:14

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

Utvid `docker-compose.yml` filen til å inkludere en MySQL-database.

<details><summary>Løsning</summary>

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: example
    ports:
      - "3306:3306"
```

**Forklaring:**

1. **Legge til en database**: Vi legger til en MySQL-tjeneste i `docker-compose.yml` filen. MySQL er en populær relasjonsdatabase.
2. **depends_on**: Dette sikrer at MySQL-tjenesten starter før web-tjenesten. Dette er viktig for å sikre at databasen er tilgjengelig når web-applikasjonen prøver å koble til den.

</details>

### **Oppgave 6: Koble applikasjonen til databasen**

> [!NOTE]  
> Sørg for at MySQL-tjenesten kjører før du prøver å koble til databasen fra applikasjonen.

Oppdater Node.js-applikasjonen til å koble til MySQL-databasen.

<details><summary>Løsning</summary>

```javascript
// app.js
const http = require('http');
const mysql = require('mysql');

const hostname = '0.0.0.0';
const port = 8080;
const dbConfig = {
  host: 'db',
  user: 'root',
  password: 'example',
  database: 'mydatabase'
};

const connection = mysql.createConnection(dbConfig);

connection.connect(err => {
  if (err) throw err;
  console.log('Connected to MySQL database');

  const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello World');
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

### **Oppgave 7: Miljøvariabler**

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
    depends_on:
      - db
    environment:
      - MYSQL_HOST=db
      - MYSQL_USER=root
      - MYSQL_PASSWORD=example
      - MYSQL_DATABASE=mydatabase
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: example
    ports:
      - "3306:3306"
```

```javascript
// app.js
const http = require('http');
const mysql = require('mysql');

const hostname = '0.0.0.0';
const port = 8080;
const dbConfig = {
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
};

const connection = mysql.createConnection(dbConfig);

connection.connect(err => {
  if (err) throw err;
  console.log(`Connected to MySQL database ${process.env.MYSQL_DATABASE}`);

  const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello World');
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