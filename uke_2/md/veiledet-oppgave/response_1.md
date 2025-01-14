## Oppgave 1: Oppsett av VPC og EC2-instans

I denne oppgaven skal du sette opp en Virtual Private Cloud (VPC) og lansere en EC2-instans som vil fungere som vår webserver.

### Oppgavebeskrivelse:

1. Opprett en ny VPC med CIDR-blokk 10.0.0.0/16, ingen IPv6 CIDR block, 2 Availability Zones, 2 public subnets, og 2 private subnets. `DNS hostnames` og `DNS resolution` skal være aktivert.
2. Lanser en t2.micro EC2-instans med Amazon Linux 2 i public subnet.
3. Konfigurer en security group for EC2-instansen som tillater innkommende trafikk på port 22 (SSH) og 80 (HTTP).

### Mermaid-diagram:

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'fontSize': '16px'}}}%%
graph TD
    A[Internet] --> B[Internet Gateway]
    B --> C[VPC: 10.0.0.0/16]
    C --> D[Public Subnet: 10.0.1.0/24]
    D --> E[EC2 Instance]
    E --> F[Security Group]
```

<details>
<summary>Løsning</summary>

1. Opprett VPC:
   - Gå til VPC Dashboard i AWS Console ved å søke på "VPC"
   - Klikk \"Create VPC\
   - Klikk \"VPC and more\"
   - Angi navn og CIDR-blokk 10.0.0.0/16
   - Tenancy "Default"
   - Number of AZs: 2
   - Number of Public Subnets: 2
   - Number of Private Subnets: 2
   - NAT gateways: None
   - VPC endpoints: None
   - DNS options (Enable DNS hostnames): Aktivert
   - DNS options (Enable DNS resolution): Aktivert
   - Klikk på \"Create VPC\"

2. Lanser EC2-instans:
    - Gå til EC2 Dashboard
    - Klikk "Launch Instance"
    - Gi den et navn
    - Velg Amazon Linux 2 AMI
    - Velg t2.micro instance type
    - Ved "Key pair (login)":
      * Velg "Create new key pair"
      * Gi key pair et navn (f.eks. "taskmanager-key")
      * Velg RSA og .pem format
      * Last ned key pair-filen og lagre den sikkert
      * Endre tillatelser på key pair: `chmod 400 taskmanager-key.pem`
    - Konfigurer \"Network Settings \" -> Trykk på Edit
        - Konfigurer instance details: Velg ditt VPC og **public** subnettet (se på navnet for å vite at det er public) i sone `eu-west-1a`
        - `Auto-assign public IP`: Enable
        - `Firewall`: Create Security Group
            - Gi den et navn
            - Inbound Security Group Rules: 
                - Type: ssh, Protocol: TCP, Port range: 22, Source Type: anywhere
                - `Add security group rule` -> Type: http, Protocol TCP, port: 80, Source Type: 0.0.0.0/0 (anywhere)

    - Konfigurer security group: Tillat inngående trafikk på port 22 og 80
    - Launch instance

I EC2-konsollet i AWS vil du nå se at EC2-instansen din står og initialiserer med `Status check` lik `Initializing`. Se bilde:

![Screenshot of AWS VPC Creation](../../../static/img/ec2-init.png)

Dette setter opp grunnleggende infrastruktur for vårt oppgavestyringssystem.

</details>

## Oppgave 2: Installasjon av webserver og database

I denne oppgaven skal du installere og konfigurere en webserver (Nginx) og en database (MySQL) på EC2-instansen.

### Oppgavebeskrivelse:

1. Koble til EC2-instansen via SSH.
2. Installer Nginx webserver.
3. Installer MySQL database server.
4. Konfigurer Nginx til å servere en enkel HTML-side som sier \"Velkommen til oppgavestyringssystemet\".
5. Opprett en database kalt \"taskmanager\" i MySQL.

### Mermaid-diagram:

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'fontSize': '16px'}}}%%
graph TD
    A[EC2 Instance] --> B[Nginx Webserver]
    A --> C[MySQL Database]
    D[Internet] --> B
```

<details>
<summary>Løsning</summary>

Før du begynner her må det settes riktige tilganger på SSH-nøkkelen. Det gjør du ved å kjøre `chmod 400 <your-key>.pem`.

1. Koble til EC2-instansen ved å kjøre følgende kommando i terminalen din:
   ```
   ssh -i your-key.pem ec2-user@your-instance-ip
   ```

   Riktig kommando kan også finnes her ved å gå inn i `EC2`-viewet til AWS, og deretter trykke på `Connect` i menyen øverst til høyre. Du trykker deg videre inn på `SSH Client`, og ser en link i bunn der som skal se noe ala dette ut: `ssh -i "taskmanager-key.pem" ec2-user@ec2-54-75-40-70.eu-west-1.compute.amazonaws.com`

    ![Screenshot of AWS VPC Creation](../../../static/img/ec2-connect.png)

    Du vil få opp følgende spørsmål ved første gang du bruker SSH inn i instansen `Are you sure you want to continue connecting (yes/no/[fingerprint])?`. Skriv `yes` og trykk enter. Du vil nå befinne deg inne i terminalen til EC2-instansen, som kan ses med følgende i terminalen: `[ec2-user@ip-10-0-10-238 ~]$`. Her vil du kunne kjøre kommandoer som `ls`, `pwd` etc. må samme måte som på lokal maskin. 

2. Installer Nginx:
   ```
   sudo yum update -y
   sudo yum install -y nginx
   sudo systemctl start nginx
   sudo systemctl enable nginx
   ```

   Du kan nå prøve å gå til IPen til EC2-instansen din ved å skrive inn IP-adressen i adressefeltet i Google Chrome og se at `Welcome to nginx!` dukker opp. 

3. Installer MySQL:
   ```
    sudo dnf install mariadb105-server mariadb105-server-utils -y
    sudo systemctl start mariadb
    sudo systemctl enable mariadb
    sudo mysql_secure_installation

    Follow prompts:
    - Enter current password for root (press Enter for none) -> yourpassword
    - Switch to unix_socket authentication [Y/n] -> n
    - Change the root password? [Y/n] -> n
    - Remove anonymous users? (Y)
    - Disallow root login remotely? (Y)
    - Remove test database and access to it? (Y)
    - Reload privilege tables now? (Y)
   ```

4. Konfigurer Nginx:
```bash
sudo tee /usr/share/nginx/html/index.html << 'EOF'
<html>
    <body>
    <h1>Velkommen til oppgavestyringssystemet</h1>
    </body>
</html>
EOF
```

5. Propager endringene til `nginx`:

```bash
sudo systemctl restart nginx
```

5. Opprett database:
   ```
   sudo mysql
   SET PASSWORD FOR 'root'@'localhost' = PASSWORD('yourpassword');
   CREATE DATABASE taskmanager;
   FLUSH PRIVILEGES;
   exit
   ```

Du har nå satt opp en webserver og en database på EC2-instansen. Du kan åpne en nettleser og gå til EC2-instansens offentlige IP-adresse for å se velkomstsiden. Du finner denne adressen i EC2 Dashboard under "Public IPv4 address".

</details>

## Oppgave 3: Implementer backend for oppgavestyring

I denne oppgaven skal du implementere en enkel backend for oppgavestyringssystemet ved hjelp av Python og Flask.

### Oppgavebeskrivelse:

1. Installer Python og nødvendige pakker på EC2-instansen.
2. Skriv en enkel Flask-applikasjon som kobler til MySQL-databasen.
3. Implementer API-endepunkter for å liste, opprette, oppdatere og slette oppgaver.
4. Konfigurer Nginx til å videresende forespørsler til Flask-applikasjonen.

### Mermaid-diagram:

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'fontSize': '16px'}}}%%
graph TD
    A[Nginx] --> B[Flask Application]
    B --> C[MySQL Database]
    D[Internet] --> A
```

<details>
<summary>Løsning</summary>

1. Installer Python og pakker:
   ```
   sudo yum remove mariadb-connector-c -y

    sudo yum install https://downloads.mariadb.com/Connectors/c/connector-c-3.3.4/mariadb-connector-c-3.3.4-1.el7.x86_64.rpm -y

    sudo yum install python3 python3-pip mariadb105-devel gcc python3-devel -y

    pip3 install --user flask flask-sqlalchemy mariadb==1.0.11 pymysql
   ```

2. Opprett Flask-applikasjon (app.py):
```bash
cat << 'EOF' > app.py
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:yourpassword@localhost/taskmanager'
db = SQLAlchemy(app)

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(200))
    status = db.Column(db.String(20), default='To Do')

@app.route('/tasks', methods=['GET'])
def get_tasks():
    tasks = Task.query.all()
    return jsonify([{'id': task.id, 'title': task.title, 'description': task.description, 'status': task.status} for task in tasks])

@app.route('/tasks', methods=['POST'])
def create_task():
    data = request.json
    new_task = Task(title=data['title'], description=data['description'])
    db.session.add(new_task)
    db.session.commit()
    return jsonify({'message': 'Task created successfully'}), 201

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000)
EOF
```

3. Konfigurer Nginx (/etc/nginx/nginx.conf):

```bash
sudo bash -c 'cat > /etc/nginx/nginx.conf << EOL
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://127.0.0.1:5000;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }
}
EOL'
```

4. Start Flask-applikasjonen:
   ```
   python3 app.py &
   ```

5. Omstart Nginx:
   ```
   sudo systemctl restart nginx
   ```

Du har nå implementert en enkel backend for oppgavestyringssystemet. Foreløpig er dette en lukket adresse da port 5000 ikke er eksponert i EC2 instansen din i security groups. Hvis du vil teste APIet ditt, f.eks. ved å skrive `http://52.31.158.146:5000/tasks` (bruk din EC2 instans sin IP adresse), så må først port 5000 legges til i inbound rules for security groupen til EC2 instansen. 

</details>

## Oppgave 4: Implementer frontend for oppgavestyring

I denne oppgaven skal du implementere en enkel frontend for oppgavestyringssystemet ved hjelp av HTML, CSS og JavaScript.

### Oppgavebeskrivelse:

1. Opprett en HTML-side med grunnleggende struktur for oppgavestyringssystemet.
2. Legg til CSS for å style siden.
3. Implementer JavaScript-kode for å interagere med backend-API-et.
4. Konfigurer Nginx til å servere frontend-filene.

### Mermaid-diagram:

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'fontSize': '16px'}}}%%
graph TD
    A[Nginx] --> B[Frontend HTML/CSS/JS]
    A --> C[Flask Backend]
    C --> D[MySQL Database]
    E[Internet] --> A
```

<details>
<summary>Løsning</summary>

1. Opprett HTML-fil (index.html):
```bash
sudo tee /usr/share/nginx/html/index.html > /dev/null << 'EOL'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Oppgavestyringssystem</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Oppgavestyringssystem</h1>
    <div id="task-list"></div>
    <form id="task-form">
        <input type="text" id="task-title" placeholder="Oppgavetittel" required>
        <textarea id="task-description" placeholder="Oppgavebeskrivelse"></textarea>
        <button type="submit">Legg til oppgave</button>
    </form>
    <script src="script.js"></script>
</body>
</html>
EOL
```

2. Opprett CSS-fil (style.css):
```bash
sudo tee /usr/share/nginx/html/style.css > /dev/null << 'EOL'
body {
    font-family: Arial, sans-serif;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}

#task-list {
    margin-bottom: 20px;
}

.task {
    border: 1px solid #ddd;
    padding: 10px;
    margin-bottom: 10px;
}

form {
    display: flex;
    flex-direction: column;
}

input, textarea, button {
    margin-bottom: 10px;
    padding: 5px;
}
EOL
```

3. Opprett JavaScript-fil (script.js):
```bash
sudo tee /usr/share/nginx/html/script.js > /dev/null << 'EOL'
async function getTasks() {
    const response = await fetch('/tasks');
    const tasks = await response.json();
    const taskList = document.getElementById('task-list');
    taskList.innerHTML = '';
    tasks.forEach(task => {
        const taskElement = document.createElement('div');
        taskElement.className = 'task';
        taskElement.innerHTML = `
            <h3>${task.title}</h3>
            <p>${task.description}</p>
            <p>Status: ${task.status}</p>
        `;
        taskList.appendChild(taskElement);
    });
}

document.getElementById('task-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const title = document.getElementById('task-title').value;
    const description = document.getElementById('task-description').value;
    await fetch('/tasks', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ title, description }),
    });
    getTasks();
    e.target.reset();
});

getTasks();
EOL
```

4. Konfigurer Nginx:
```bash
sudo tee /etc/nginx/nginx.conf > /dev/null << 'EOL'
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name _;

        location / {
            root /usr/share/nginx/html;
            index index.html;
            try_files $uri $uri/ /index.html;
        }

        location /tasks {
            proxy_pass http://127.0.0.1:5000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
EOL
```

5. Omstart Nginx:
```
sudo systemctl restart nginx
```

Du har nå implementert en enkel frontend for oppgavestyringssystemet. Du kan åpne en nettleser og gå til EC2-instansens offentlige IP-adresse for å se og bruke applikasjonen.

For å teste dette, kan du:

1. Finne den offentlige IP-adressen til EC2-instansen:
    - Gå til EC2 Dashboard i AWS Console
    - Velg din instans
    - Se under "Public IPv4 address"

2. Åpne en nettleser og besøk:
    - Frontend: `http://<din-ec2-ip>`
    - Backend API: `http://<din-ec2-ip>/tasks`

3. Test API-endepunktene:
    - GET `/tasks` - List alle oppgaver
    - POST `/tasks` - Opprett ny oppgave

For å teste POST-endepunktet kan du bruke cURL:
```bash
curl -X POST http://<din-ec2-ip>/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Oppgave","description":"Dette er en test"}'
```

</details>

## Oppgave 5: Migrering til containere med Docker på EC2

<!-- ## AWS Konfigurasjon og Access Keys

Før du begynner må du sette opp AWS CLI og programatisk aksess til AWS via Terminal. Dette vil vi gå dypere inn på i neste uke, men for å kunne gjøre operasjonene vi ønsker her er vi nødt til å sette det opp. Det er forsøkt å holde bruk av AWS CLI i denne ukens oppgaver til et absolutt minimum. 

### Opprette Access Keys i AWS
1. Logg inn på AWS Management Console
2. Gå til IAM -> Users -> Klikk på brukernavnet ditt øverst til høyre, eventuelt `admin`
3. Velg "Security credentials"
4. Under "Access keys", klikk på "Create access key"
5. Noter ned Access Key ID og Secret Access Key (dette er eneste gang du får se Secret Access Key)
6. Last ned .csv-filen for sikker oppbevaring

### Konfigurere AWS CLI med profil
1. Installer AWS CLI hvis du ikke har gjort det allerede
2. Åpne terminal
3. Kjør kommandoen:
    ```bash
    aws configure --profile gokstad
    ```
4. Du vil bli bedt om å fylle inn følgende:
    - AWS Access Key ID: [Lim inn Access Key ID]
    - AWS Secret Access Key: [Lim inn Secret Access Key]
    - Default region name: [eu-west-1]
    - Default output format: [Enter for json] -> Trykk enter

### Tips
- Hold access keys sikre og del aldri disse med andre
- Roter keys regelmessig for økt sikkerhet
- Bruk separate profiler for ulike AWS-kontoer
- For å verifisere at profilen er satt opp korrekt:
  ```bash
  aws sts get-caller-identity --profile gokstad
  ```

> [!IMPORTANT]
> Husk å aldri dele eller committe access keys til versjonskontroll! -->


Her skal du migrere applikasjonen til containere ved hjelp av Docker på EC2.

> [!NOTE]
> I denne oppgaven gjør du oppgave 1 og 2 lokalt på din maskin, og deretter oppgave 3 og 4 på EC2-instansen via SSH. 

### Oppgavebeskrivelse:

1. Opprett Dockerfiler for frontend og backend lokalt.
2. Bygg Docker-images og push dem til Amazon Dockerhub (Elastic Container Registry).
3. Installer Docker på EC2-instansen.
4. Pull images fra DockerHub og kjør containere på EC2.

### Mermaid-diagram:

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'fontSize': '16px'}}}%%
graph TD
    A[EC2 Instance<br>Amazon Linux 2]
    A --> B[Docker: Frontend<br>Container nginx:alpine]
    A --> C[Docker: Backend<br>Container python:3.8]
    C --> D[MySQL Database<br>MariaDB 10.5]
    E[DockerHub] --> A
```

<details>
<summary>Løsning</summary>

1. Først må vi opprette filene og Dockerfiles lokalt. Før du oppretter disse må du korrigere `API_ENDPOINT` i script.js nedenfor og sette den til din EC2 instans sin public IP:

```bash
cat << 'EOF' > requirements.txt
flask
flask-sqlalchemy
mariadb==1.0.11
pymysql
flask-cors
EOF

cat << 'EOF' > app.py
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={
    r"/*": {
        "origins": "*",
        "methods": ["GET", "POST"],
        "allow_headers": ["Content-Type"]
    }
})
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:yourpassword@host.docker.internal:3306/taskmanager'
db = SQLAlchemy(app)

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(200))
    status = db.Column(db.String(20), default='To Do')

@app.route('/tasks', methods=['GET'])
def get_tasks():
    tasks = Task.query.all()
    return jsonify([{'id': task.id, 'title': task.title, 'description': task.description, 'status': task.status} for task in tasks])

@app.route('/tasks', methods=['POST'])
def create_task():
    data = request.json
    new_task = Task(title=data['title'], description=data['description'])
    db.session.add(new_task)
    db.session.commit()
    return jsonify({'message': 'Task created successfully'}), 201

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000)
EOF

mkdir -p frontend/html

cat << 'EOF' > frontend/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>Oppgavestyringssystem</title>
     <link rel="stylesheet" href="style.css">
</head>
<body>
     <h1>Oppgavestyringssystem</h1>
     <div id="task-list"></div>
     <form id="task-form">
          <input type="text" id="task-title" placeholder="Oppgavetittel" required>
          <textarea id="task-description" placeholder="Oppgavebeskrivelse"></textarea>
          <button type="submit">Legg til oppgave</button>
     </form>
     <script src="script.js"></script>
</body>
</html>
EOF

cat << 'EOF' > frontend/html/style.css
body {
    font-family: Arial, sans-serif;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}

#task-list {
    margin-bottom: 20px;
}

.task {
    border: 1px solid #ddd;
    padding: 10px;
    margin-bottom: 10px;
}

form {
    display: flex;
    flex-direction: column;
}

input, textarea, button {
    margin-bottom: 10px;
    padding: 5px;
}
EOF

cat << 'EOF' > frontend/html/script.js
const API_ENDPOINT = 'http://52.16.19.129:5000';

async function getTasks() {
    const response = await fetch(`${API_ENDPOINT}/tasks`);
    const tasks = await response.json();
    const taskList = document.getElementById('task-list');
    taskList.innerHTML = '';
    tasks.forEach(task => {
        const taskElement = document.createElement('div');
        taskElement.className = 'task';
        taskElement.innerHTML = `
            <h3>${task.title}</h3>
            <p>${task.description}</p>
            <p>Status: ${task.status}</p>
        `;
        taskList.appendChild(taskElement);
    });
}

document.getElementById('task-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const title = document.getElementById('task-title').value;
    const description = document.getElementById('task-description').value;
    await fetch(`${API_ENDPOINT}/tasks`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ title, description }),
    });
    getTasks();
    e.target.reset();
});

getTasks();
EOF
```

Opprett Dockerfile for backend:
```bash
cat << 'EOF' > Dockerfile-backend
FROM python:3.8-slim-buster
WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
EOF
```

Opprett Dockerfile for frontend:
```bash
cat << 'EOF' > Dockerfile-frontend
FROM nginx:alpine
COPY frontend/html/* /usr/share/nginx/html/
EOF
```

2. Bygg og push Docker-images:
```bash
# Logg inn på Docker Hub
docker login

# Bygg images
docker build --platform linux/amd64 -t flaattengokstad/taskmanager-backend:latest -f Dockerfile-backend .
docker build --platform linux/amd64 -t flaattengokstad/taskmanager-frontend:latest -f Dockerfile-frontend .

# Push til Docker Hub
docker push flaattengokstad/taskmanager-frontend:latest
docker push flaattengokstad/taskmanager-backend:latest
```

3. Installer Docker på EC2:

Bruk SSH for å komme deg inn på EC2-instansen fra din egen maskin.

```bash
ssh -i "your-key.pem" ec2-user@your-ec2-ip

sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
exit
```

4. Installer MySQL på samme måte som i oppgave 2:
```
sudo dnf install mariadb105-server mariadb105-server-utils -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation
# Follow prompts:
# - Enter current password for root (press Enter for none)
# - Set root password (remember this)
# - Remove anonymous users? (Y)
# - Disallow root login remotely? (Y)
# - Remove test database and access to it? (Y)
# - Reload privilege tables now? (Y)


# Create database
sudo mysql

CREATE USER 'root'@'%' IDENTIFIED BY 'yourpassword';

CREATE DATABASE taskmanager;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

exit
```

5. Pull og kjør containere på EC2:

SSH inn på EC2-instansen hvis du ikke allerede er inne på den:

```bash
ssh -i "your-key.pem" ec2-user@your-ec2-ip
```

Kjør disse kommandoene på EC2-instansen:

```bash
docker pull flaattengokstad/taskmanager-frontend:latest
docker pull flaattengokstad/taskmanager-backend:latest

docker run -d --name backend --add-host=host.docker.internal:host-gateway -p 5000:5000 flaattengokstad/taskmanager-backend:latest
docker run -d --name frontend -p 80:80 flaattengokstad/taskmanager-frontend:latest
```

</details>

## Oppgave 6: Konfigurering av Security Groups for Docker

I denne oppgaven skal du konfigurere security groups for å sikre riktig nettverkstilgang til Docker-containerne. Det kan være at du allerede har gjort dette i oppgave 5, men hvis du sliter med å få frontend til å snakke med frontend er det sannsynligvis fordi du ikke har åpnet port 5000 på EC2 instansen. Se i såfall oppgaven under:

### Oppgavebeskrivelse:

1. Oppdater security group for EC2-instansen.
2. Legg til inbound regler for Docker-containerne.
3. Verifiser at reglene er korrekt implementert.
4. Test tilgjengeligheten til applikasjonen.

### Mermaid-diagram:

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'fontSize': '16px'}}}%%
graph TD
    A[Internet] --> B[EC2 Security Group]
    B -->|Port 80| C[Docker: Frontend]
    B -->|Port 5000| D[Docker: Backend]
```

<details>
<summary>Løsning</summary>

1. Finn EC2 security group:
```bash
# Gå til EC2 Dashboard i AWS Console
# Velg din instans
# Klikk på security group linken
```

2. Konfigurer inbound regler:
```bash
# I security group:
- Velg "Edit inbound rules"
- Legg til: Type=Custom TCP, Port=80, Source=0.0.0.0/0 (for frontend)
- Legg til: Type=Custom TCP, Port=5000, Source=0.0.0.0/0 (for backend)
- Behold eksisterende SSH regel (port 22)
```

3. Test tilgang:
```bash
# Test frontend
curl http://[din-ec2-ip]

# Test backend
curl http://[din-ec2-ip]:5000/tasks
```

4. For å se Docker container logs:
```bash
docker logs frontend
docker logs backend
```

</details>
