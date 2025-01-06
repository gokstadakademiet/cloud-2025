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



