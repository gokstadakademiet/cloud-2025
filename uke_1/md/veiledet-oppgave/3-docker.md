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