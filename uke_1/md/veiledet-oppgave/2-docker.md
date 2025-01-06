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
