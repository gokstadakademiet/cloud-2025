# Oppgavesett: AWS - Console, VPC og EC2
# Innholdsfortegnelse

# Innholdsfortegnelse 

1. [Oppsett av infrastruktur](#oppgave-1-sett-opp-infrastruktur)
2. [Sett opp database](#oppgave-2-sett-opp-database)
3. [Sett opp backend-applikasjon med Docker](#oppgave-3-sett-opp-backend-applikasjon-med-docker)
4. [Implementer logging og overvåkning](#oppgave-4-implementer-logging-og-overvåkning)
5. [Custom CloudWatch Metrics](#oppgave-5-custom-cloudwatch-metrics)
6. [Implementering av AWS Lambda for periodiske oppgaver](#oppgave-6-ekstra-oppgave-for-de-som-vil-teste-er-i-utgangspunktet-neste-ukes-pensum-implementering-av-aws-lambda-for-periodiske-oppgaver)

# Introduksjon til skyteknologi med AWS: Oppgavestyringssystem

I dette kurset skal vi bygge et enkelt oppgavestyringssystem ved hjelp av AWS-tjenester. Vi vil starte med grunnleggende oppsett og gradvis bygge ut funksjonaliteten. Kurset vil fokusere på infrastruktur og AWS-tjenester, med minimal vekt på applikasjonskode.

> [!NOTE]
> **Før du begynner er det viktig at du setter deg inn i AWS Free Tier, se artikkel [her](../aws.md).**

> [!NOTE]
> **Hvis du bruker Windows er det lurt å laste ned Git Bash og bruke det som terminal for oppgavene, fremfor f.eks. PowerShell som er typisk på Windows. Du vil da kunne kjøre samme kommandoer som vist i ukesoppgavene Se video for hvordan Git Bash installeres [her](https://www.youtube.com/watch?v=qdwWe9COT9k).**

# Oppgaver: Oppgavestyringssystem i AWS

I disse oppgavene skal vi bygge et enkelt oppgavestyringssystem ved hjelp av AWS-tjenester. Vi vil fokusere på å bruke AWS Console, VPC, EC2, ECS, CloudWatch, IAM, S3 og RDS. Oppgavene bygger på hverandre, så sørg for å fullføre dem i rekkefølge.

## Oppgave 1: Sett opp infrastruktur

I denne oppgaven skal du sette opp grunnleggende infrastruktur for oppgavestyringssystemet vårt.

### 1a. Opprett en VPC

Opprett en ny VPC med følgende spesifikasjoner:
- CIDR-blokk: 10.0.0.0/16
- 2 offentlige subnett i forskjellige Availability Zones
- 1 Internet Gateway
- 1 Route Table for de offentlige subnettene

### 1b. Opprett en EC2-instans

Lag en EC2-instans med følgende spesifikasjoner:
- Amazon Linux 2
- t2.micro (Free Tier eligible)
- Plasser den i ett av de offentlige subnettene
- Opprett en ny security group som tillater innkommende trafikk på port 22 (SSH) og 80 (HTTP) og 5000 (TCP)

### 1c. Opprett en S3-bucket

Opprett en S3-bucket som vil bli brukt til å lagre statiske filer for oppgavestyringssystemet.

### Arkitekturdiagram

```mermaid
graph TB
    Internet((Internet))
    VPC[VPC: 10.0.0.0/16]
    IG[Internet Gateway]
    PublicSubnet1[Public Subnet 1]
    PublicSubnet2[Public Subnet 2]
    EC2[EC2 Instance]
    S3[S3 Bucket]

    Internet --> IG
    IG --> VPC
    VPC --> PublicSubnet1
    VPC --> PublicSubnet2
    PublicSubnet1 --> EC2
    Internet --> S3
```

<details>
<summary>Løsning</summary>

### 1a. Opprett en VPC

1. Gå til VPC-konsollet i AWS.
2. Klikk på \"Create VPC\".
3. Velg \"VPC and more\" for å opprette VPC med tilhørende ressurser.
4. Fyll inn følgende detaljer:
   - VPC navn: OppgavestyringVPC
   - IPv4 CIDR block: 10.0.0.0/16
   - Number of Availability Zones: 2
   - Number of public subnets: 2
   - Number of private subnets: 0
   - NAT gateways: None
   - VPC endpoints: None
   - DNS options (Enable DNS hostnames): Aktivert
   - DNS options (Enable DNS resolution): Aktivert
5. Klikk på \"Create VPC\".

### 1b. Opprett en EC2-instans

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
                - `Add security group rule` -> Type: TCP, Protocol TCP, port: 5000, Source Type: 0.0.0.0/0 (anywhere)
    - Launch instance

### 1c. Opprett en S3-bucket

1. Gå til S3-konsollet i AWS.
2. Klikk på \"Create bucket\" -> General Purpose
3. Velg et unikt navn for bucketen (f.eks. oppgavestyring-filer-\<ditt-navn\>).
4. La alle andre innstillinger være som standard.
5. Klikk på \"Create bucket\".

Du har nå satt opp grunnleggende infrastruktur for oppgavestyringssystemet vårt.

</details>


## Oppgave 2: Sett opp database i AWS RDS

I denne oppgaven skal vi sette opp en MySQL-database ved hjelp av Amazon RDS for å lagre oppgaver og brukerinformasjon.

Opprett en Amazon RDS MySQL-instans med følgende spesifikasjoner:
- Easy Create
- Engine: MySQL
- Instance class: Free Tier (db.t4g.micro)
- DB Instance Identifier: taskmanager 
- Plasser den i samme VPC som EC2-instansen, men i et annet subnet
- Bruk `Connect to an EC2 compute resource` for å sørge for at RDS-instansen tillater innkommende trafikk på port 3306 (MySQL) fra EC2-instansens security group.

### Arkitekturdiagram

```mermaid
graph TB
    Internet((Internet))
    VPC[VPC: 10.0.0.0/16]
    IG[Internet Gateway]
    PublicSubnet1[Public Subnet 1]
    PublicSubnet2[Public Subnet 2]
    EC2[EC2 Instance]
    S3[S3 Bucket]
    RDS[(RDS MySQL)]

    Internet --> IG
    IG --> VPC
    VPC --> PublicSubnet1
    VPC --> PublicSubnet2
    PublicSubnet1 --> EC2
    PublicSubnet2 --> RDS
    Internet --> S3
    EC2 --> RDS
```


<details>
<summary>Løsning</summary>

**Se bilde i steg 4. Default selektert RDS Database Instance size koster penger. Selekter `Free Tier` med `tb.t4g.micro`**

![Screenshot of AWS RDS Free Tier](../static/img/rds-free-tier.png)

1. Gå til RDS-konsollet i AWS.
2. Klikk på \"Create database\".
3. Velg "Standard Create" og MySQL som engine type.
4. Fyll inn følgende detaljer:
   - DB instance identifier: oppgavestyring-db
   - Master username: admin
   - Master password: Velg et passord
5. Bekreft at DB instance type er satt til Free tier (db.4tg.micro) -> se bilde. De andre typene er ikke under free tier og koster penger.
6. Set up EC2 connection (under `Connectivity`):
   - Sjekk av på "Connect to an EC2 compute resource" (AWS vil da sette opp nødvendige rettigheter, security groups etc. automatisk for deg slik at EC2-instansen og databasen kan snakke sammen)
   - Selekter EC2-instansen du skal koble til databasen
7. Under \"Additional configuration\":
  - Sett initial database name til \"taskmanager\".
  - Skru av `Enable automated backups`
8. La alle andre innstillinger være som standard.
9. Bekrefte at det står noe ala følgende under `Estimated monthly costs`:
   - The Amazon RDS Free Tier is available to you for 12 months. Each calendar month, the free tier will allow you to use the Amazon RDS resources listed below for free:
   - 750 hrs of Amazon RDS in a Single-AZ db.t2.micro, db.t3.micro or db.t4g.micro Instance.
   - 20 GB of General Purpose Storage (SSD).
   - 20 GB for automated backup storage and any user-initiated DB Snapshots.
10. Klikk på \"Create database\". Det tar noen minutter før den er klar (med status `Available`)

Trykk `Close` hvis du får følgende popup:

![Screenshot of AWS RDS Free Tier](../static/img/rds-create-popup.png)

Nå har du satt opp en MySQL-database og konfigurert sikkerhetsgrupper for å tillate tilkobling fra EC2-instansen.

> [!NOTE]
> Husk å lagre tilkoblingsinformasjonen for databasen (endpoint, brukernavn, passord) på et sikkert sted. Du vil trenge denne informasjonen senere når du skal koble applikasjonen til databasen.

</details>

## Oppgave 3: Konfigurasjon for RDS database på EC2-instansen

I denne oppgaven skal du installere og konfigurere en webserver (Nginx) og konfigurasjon for å kunne koble EC2 instansen til MySQL databasen din i AWS RDS.

### Oppgavebeskrivelse:

1. Koble til EC2-instansen via SSH.
2. Installer MySQL dependencies for RDS.
3. Opprett en database kalt \"taskmanager\" i MySQL.

<details>
<summary>Løsning</summary>

Før du begynner her må det settes riktige tilganger på SSH-nøkkelen. Det gjør du ved å kjøre `chmod 400 <your-key>.pem`.

1. Koble til EC2-instansen ved å kjøre følgende kommando i terminalen din:
  ```
  ssh -i your-key.pem ec2-user@your-instance-ip
  ```

  Riktig kommando kan også finnes her ved å gå inn i `EC2`-viewet til AWS, og deretter trykke på `Connect` i menyen øverst til høyre. Du trykker deg videre inn på `SSH Client`, og ser en link i bunn der som skal se noe ala dette ut: `ssh -i "taskmanager-key.pem" ec2-user@ec2-54-75-40-70.eu-west-1.compute.amazonaws.com`

   ![Screenshot of AWS VPC Creation](../static/img/ec2-connect.png)

   Du vil få opp følgende spørsmål ved første gang du bruker SSH inn i instansen `Are you sure you want to continue connecting (yes/no/[fingerprint])?`. Skriv `yes` og trykk enter. Du vil nå befinne deg inne i terminalen til EC2-instansen, som kan ses med følgende i terminalen: `[ec2-user@ip-10-0-10-238 ~]$`. Her vil du kunne kjøre kommandoer som `ls`, `pwd` etc. må samme måte som på lokal maskin. 

2. Installer MySQL:
  ```
   sudo dnf update -y
   sudo dnf install mariadb105 -y
  ```

3. Opprett database:
  ```
   mysql -h <RDS_ENDPOINT> -u admin -p
  
  CREATE DATABASE taskmanager;
  exit
  ```

Du har nå installert MySQL og opprettet en database som skal brukes av oppgavestyringssystemet. Denne databasen vil bli brukt i de neste oppgavene når vi setter opp webapplikasjonen.

</details>

## Oppgave 4: Sett opp frontend og backend i Docker på EC2-instansen

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


Brukes samme kode som i oppgave 5 fra forrige uke. 

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
pymysql
flask-cors
EOF

cat << 'EOF' > app.py
# filepath: app.py
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

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:<your_password>@<YOUR_RDS_ENDPOINT>/taskmanager'
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
  new_task = Task(title=data['title'], description=data.get('description', ''))
  db.session.add(new_task)
  db.session.commit()
  return jsonify({'id': new_task.id, 'title': new_task.title, 'description': new_task.description, 'status': new_task.status}), 201

if __name__ == '__main__':
  with app.app_context():
    db.create_all()
  app.run(host='0.0.0.0', port=80)
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
async function getTasks() {
    const response = await fetch(`http://${window.location.hostname}:5000/tasks`);
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
    await fetch(`http://${window.location.hostname}:5000/tasks`, {
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

EXPOSE 80
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
docker build --platform linux/amd64 -t <your-dockerhub-account>/taskmanager-backend:latest -f Dockerfile-backend .
docker build --platform linux/amd64 -t <your-dockerhub-account>/taskmanager-frontend:latest -f Dockerfile-frontend .

# Push til Docker Hub
docker push <your-dockerhub-account>/taskmanager-frontend:latest
docker push <your-dockerhub-account>/taskmanager-backend:latest
```

3. Installer Docker på EC2:

Bruk SSH for å komme deg inn på EC2-instansen fra din egen maskin.

```bash
ssh -i "your-key.pem" ec2-user@your-ec2-ip

sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
```

4. Pull og kjør containere på EC2:

Kjør disse kommandoene på EC2-instansen:

```bash
docker pull <your-dockerhub-account>/taskmanager-frontend:latest
docker pull <your-dockerhub-account>/taskmanager-backend:latest

docker run -d --name backend -p 5000:80 <your-dockerhub-account>/taskmanager-backend:latest
docker run -d --name frontend -p 80:80 <your-dockerhub-account>/taskmanager-frontend:latest
```

</details>

## Oppgave 5: Implementer logging og overvåkning

I denne oppgaven skal vi implementere logging og overvåkning for vår backend-applikasjon ved hjelp av Amazon CloudWatch.

### 5a. Konfigurer IAM-rolle for CloudWatch
- Opprett en IAM-rolle med nødvendige CloudWatch-rettigheter
- Tildel rollen til EC2-instansen
- Verifiser at EC2 har tilgang til CloudWatch

### 5b. Konfigurer CloudWatch Agent
- Installer CloudWatch Agent på EC2-instansen
- Opprett konfigurasjonsfil for CloudWatch Agent
- Konfigurer agenten til å samle CPU, minne og disk metrics
- Start CloudWatch Agent

### 5c. Modifiser Python-applikasjonen
- Legg til logging i Python-applikasjonen
- Konfigurer logging til å skrive til /var/log/taskmanager.log
- Implementer logging for alle API-kall

### 5d. Opprett CloudWatch Dashboard
- Opprett et nytt dashboard kalt "TaskManager-Dashboard"
- Legg til widgets for CPU, minne og disk metrics
- Legg til widget for applikasjonslogger

### Arkitekturdiagram

```mermaid
graph TB
  Internet((Internet))
  VPC[VPC: 10.0.0.0/16]
  IG[Internet Gateway]
  PublicSubnet1[Public Subnet 1]
  PublicSubnet2[Public Subnet 2]
  EC2[EC2 Instance]
  S3[S3 Bucket]
  RDS[(RDS MySQL)]
  CW[CloudWatch]
  
  Internet --> IG
  IG --> VPC
  VPC --> PublicSubnet1
  VPC --> PublicSubnet2
  PublicSubnet1 --> EC2
  PublicSubnet2 --> RDS
  EC2 --> CW
  Internet --> S3
```

<details>
<summary>Løsning</summary>

### 5a. Konfigurer IAM-rolle

1. Opprett IAM-rolle:
   - Gå til IAM i AWS Console
   - Velg "Roles" -> "Create role"
   - Velg "AWS service" og "EC2" -> Next
   - Legg til "Permissions Policy" som heter `AWSOpsWorksCloudWatchLogs`. Den har følgende policy:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        }
    ]
}
```
  - Gi rollen et navn
  - Bekreft at `AWSOpsWorksCloudWatchLogs` ligger under `Permissions policy summary`
  - Trykk på `Create role`

2. Tildel rollen til EC2:
   - Gå til EC2 i AWS Console
   - Velg din instans
   - Gå til `Actions` (knapp i høyre hjørne) -> `Security` -> Modify IAM role
   - Velg den nye rollen
   - Klikk "Save"


### 5b. Konfigurer CloudWatch Agent

Først skal vi opprette en CloudWatch log group og deretter konfigurere CloudWatch Agent på EC2-instansen.

1. Opprett CloudWatch log group:
    - Gå til CloudWatch i AWS-konsollet
    - Klikk på "Log groups" i venstremenyen
    - Klikk på "Create log group" knappen
    - I "Log group name" feltet, skriv inn "taskmanager-logs"
    - La andre innstillinger være som standard
    - Klikk "Create" knappen for å opprette log gruppen

2. Koble til EC2-instansen og installer CloudWatch Agent:
```bash
sudo yum install amazon-cloudwatch-agent -y
```

3. Opprett konfigurasjonsfil:
```bash
sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json << 'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/taskmanager.log",
            "log_group_name": "taskmanager-logs",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  },
  "metrics": {
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_user", "cpu_usage_system"]
      },
      "memory": {
        "measurement": ["mem_used_percent"]
      },
      "disk": {
        "measurement": ["used_percent"],
        "resources": ["/"]
      }
    }
  }
}
EOF
```

4. Verifiser at konfigurasjonsfilen ble opprettet:
```bash
cat /opt/aws/amazon-cloudwatch-agent/bin/config.json
```

5. Start agenten:
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
```

### 5c. Modifiser Python-applikasjonen

Husk å endre `YOUR_RDS_ENDPOINT` til ditt RDS endpoint. Det finner du i AWS-konsollet på RDS-siden inne på din RDS database.

1. Oppdater app.py med logging:
```bash
cat << 'EOF' > app.py
import logging
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

logging.basicConfig(
  filename='/var/log/taskmanager.log',
  level=logging.INFO,
  format='%(asctime)s - %(levelname)s - %(message)s'
)

app = Flask(__name__)
CORS(app, resources={
    r"/*": {
        "origins": "*",
        "methods": ["GET", "POST"],
        "allow_headers": ["Content-Type"]
    }
})

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:<your-password>@<YOUR_RDS_ENDPOINT/taskmanager'
db = SQLAlchemy(app)

class Task(db.Model):
  id = db.Column(db.Integer, primary_key=True)
  title = db.Column(db.String(100), nullable=False)
  description = db.Column(db.String(200))
  status = db.Column(db.String(20), default='To Do')

@app.route('/tasks', methods=['GET'])
def get_tasks():
  logging.info('Fetching all tasks')
  tasks = Task.query.all()
  return jsonify([{'id': task.id, 'title': task.title, 'description': task.description, 'status': task.status} for task in tasks])

@app.route('/tasks', methods=['POST'])
def create_task():
  data = request.json
  logging.info(f'Creating new task: {data}')
  try:
    new_task = Task(title=data['title'], description=data.get('description', ''))
    db.session.add(new_task)
    db.session.commit()
    return jsonify({'id': new_task.id, 'title': new_task.title, 'description': new_task.description, 'status': new_task.status}), 201
  except Exception as e:
    logging.error(f'Error creating task: {str(e)}')
    return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
  with app.app_context():    # Add application context
        db.create_all()
  app.run(host='0.0.0.0', port=80)
EOF
```

Dytt den oppdaterte opp til Dockerhub og pull den ned på EC2-instansen:

```bash

# Local machine
docker build --platform linux/amd64 -t <your-dockerhub-account>/taskmanager-backend:latest -f Dockerfile-backend .
docker push <your-dockerhub-account>/taskmanager-backend:latest

# SSH into EC2
ssh -i "key.pem" ec2-user@your-ec2-ip

# On EC2
docker stop $(docker ps -q)  # Stop running container
docker rm $(docker ps -a -q)  # Remove old container
docker pull <your-dockerhub-account>/taskmanager-backend:latest
docker run -d --name backend -p 5000:80 -v /var/log:/var/log <your-dockerhub-account>/taskmanager-backend:latest
docker run -d --name frontend -p 80:80 <your-dockerhub-account>/taskmanager-frontend:latest

# Test API med logging
curl -X POST -H "Content-Type: application/json" -d '{"title":"Test Task"}' http://<EC2-IP>:5000/tasks

# Verify logs
tail -f /var/log/taskmanager.log
```

Du skal nå også kunne se at disse havner i AWS konsollet i Cloudwatch ved å:

1. Logg inn på AWS Management Console
2. Navigér til CloudWatch tjenesten
3. Velg "Log groups" i venstremenyen
4. Søk etter "taskmanager-logs"
5. Klikk på log gruppen for å se strømmende logger
6. For sanntidsovervåkning, klikk på "Start streaming" knappen

## Tips
- Hold øye med responstider og feilmeldinger i loggene
- Verifiser at nye oppgaver blir lagret korrekt
- Sjekk at JSON-formateringen er korrekt i API-kallet
- Ved feil, se etter ERROR eller WARN meldinger i loggstrømmen

### 5d. Opprett CloudWatch Dashboard

1. Gå til CloudWatch i AWS Console
2. Velg "Dashboards" → "Create dashboard"
3. Gi dashboardet navnet "TaskManager-Dashboard"
4. Legg til widgets (line):
   - Data Type: Metrics, Widget Type: Line -> CPU Utilization
   - Data Type: Logs, Widget Type: Logs Table -> Selection Criteria: `taskmanager-logs` -> `Create widget`
5. Trykk på `Save` øverst i høyre hjørne for å lagre Dashboard
</details>

## Oppgave 6: Custom CloudWatch Metrics

I denne oppgaven skal du implementere custom metrics for å spore aktiviteten i oppgavestyringssystemet.

### Oppgavebeskrivelse:

1. Implementer følgende custom metrics i applikasjonen:
   - TasksCreated: Teller nye oppgaver
   - TasksCompleted: Teller fullførte oppgaver
2. Konfigurer IAM rolle for CloudWatch metrics på EC2-instansen
3. Legg til metrikk-widgets i CloudWatch dashboard

### 6a. Implementer Custom Metrics

Oppdater Python-applikasjonen for å inkludere custom metrics:

Bruk følgende kode for å sende metrics:
```python
cloudwatch.put_metric_data(
    Namespace='TaskManagerMetrics',
    MetricData=[{
        'MetricName': 'TasksCreated',
        'Value': 1,
        'Unit': 'Count'
    }]
)
```

<details> <summary>Løsning</summary>

1. Legg til boto3 i `requirements.txt` for å kunne gjøre kall mot AWS i backend-koden: (TODO: ADD GIT DIFF)
```text
flask
flask-sqlalchemy
pymysql
boto3
flask-cors
```

2. Oppdater app.py med custom metrics: (TODO: ADD GIT DIFF)

Husk å endre `YOUR_RDS_ENDPOINT` til ditt RDS endpoint. Det finner du i AWS-konsollet på RDS-siden inne på din RDS database. 

```python
import boto3
import logging
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

logging.basicConfig(
  filename='/var/log/taskmanager.log',
  level=logging.INFO,
  format='%(asctime)s - %(levelname)s - %(message)s'
)

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:<your_password>@<YOUR_RDS_ENDPOINT>/taskmanager'
db = SQLAlchemy(app)
cloudwatch = boto3.client('cloudwatch', region_name='eu-west-1')

class Task(db.Model):
  id = db.Column(db.Integer, primary_key=True)
  title = db.Column(db.String(100), nullable=False)
  description = db.Column(db.String(200))
  status = db.Column(db.String(20), default='To Do')

@app.route('/tasks', methods=['GET'])
def get_tasks():
  logging.info('Fetching all tasks')
  tasks = Task.query.all()
  return jsonify([{'id': task.id, 'title': task.title, 'description': task.description, 'status': task.status} for task in tasks])

@app.route('/tasks', methods=['POST'])
def create_task():
  data = request.json
  logging.info(f'Creating new task: {data}')
  try:
    new_task = Task(title=data['title'], description=data.get('description', ''))
    db.session.add(new_task)
    db.session.commit()
    
    # Send custom metric
    cloudwatch.put_metric_data(
      Namespace='TaskManagerMetrics',
      MetricData=[{
        'MetricName': 'TasksCreated',
        'Value': 1,
        'Unit': 'Count'
      }]
    )
    
    return jsonify({'id': new_task.id, 'title': new_task.title}), 201
  except Exception as e:
    logging.error(f'Error creating task: {str(e)}')
    return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
  with app.app_context():    # Add application context
        db.create_all()
  app.run(host='0.0.0.0', port=80)
```

Dytt den oppdaterte opp til Dockerhub og pull den ned på EC2-instansen:

```bash
# Local machine
docker build --platform linux/amd64 -t taskmanager .
docker tag taskmanager:latest <your-dockerhub-account>/taskmanager:latest
docker push <your-dockerhub-account>/taskmanager:latest
```

</details> 

### 6b. Konfigurere IAM rolle for CloudWatch Metrics

Oppdater IAM rollen til å inkludere mulighet for å sende metrics til CloudWatch. Bruk `"cloudwatch:PutMetricData"` i actions. 

<details>
<summary>Løsning</summary>

1. Verifiser at EC2-instansen har riktige IAM-rettigheter:
- Gå til IAM console og finn rollen til EC2-instansen din
- Oppdater IAM rollen ved å trykke på `Add permissions` -> `Create inline policy` -> `JSON` -> og copy-paste JSON under:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*"
    }
  ]
}
```
- Trykk på `Next`
- Gi den et navn, f.eks. `PutMetricDataPolicy`
- Valider at du får opp følgende under `Permissions defined in this policy`:
  ``` 
  CloudWatch
  Limited: Write
  All resources
  None
  ```
- Trykk på `Create Policy`

</details>

### 6c. Deploy det nye Docker imaget på EC2-instansen

Det nye Docker imaget inneholder ny kode som pusher opp custom metrics til Cloudwatch. Vi skal nå kjøre i gang dette imaget. 

```bash
# SSH into EC2
ssh -i "key.pem" ec2-user@your-ec2-ip

# On EC2
docker stop $(docker ps -q)  # Stop running container
docker rm $(docker ps -a -q)  # Remove old container
docker pull <your-dockerhub-account>/taskmanager:latest
docker run -d \
  -p 80:80 \
  -v /var/log:/var/log \
  <your-dockerhub-account>/taskmanager:latest

# Test API med logging
curl -X POST -H "Content-Type: application/json" -d '{"title":"Test Task"}' http://localhost/tasks
```

### 6d. Konfigurer Dashboard

Sett opp et CloudWatch DashBoard som viser den nye metrikken `TaskManagerMetrics`.

<details>
<summary>Løsning</summary>

1. Naviger til CloudWatch Dashboard:
   - Åpne AWS Console
   - Søk etter "CloudWatch"
   - Velg "Dashboards" i venstremenyen
   - Velg "TaskManager-Dashboard" (fra oppgave 4)

2. Legg til widget for custom metrics:
   - Klikk "Add widget"
   - Velg "Line" under "Metrics"
   - Klikk "Configure"
   - Under "Browse", velg "TaskManagerMetrics"
   - Velg "TasksCreated" metric
   - Klikk "Create widget"
   - Trykk på `Save` øverst i høyre hjørne for å lagre Dashboard

3. Konfigurer widget:
   - Endre tidsvindu til "Last hour" (øverst høyre)
   - Endre tittel til "Tasks Created"
   - Under "Graphed metrics":
     - Period: 1 minute
     - Statistic: Sum
     - Unit: Count

4. Verifiser metrics:
   - Test API-endepunkt:
     ```bash
     curl -X POST \
       -H "Content-Type: application/json" \
       -d '{"title":"Test Metric","description":"Testing CloudWatch metrics"}' \
       http://<din-ec2-ip>/tasks
     ```
   - Vent 1-2 minutter (metrics har forsinkelse)
   - Refresh dashboard
   - Verifiser at ny datapunkt vises i grafen

> [!NOTE]
> CloudWatch metrics har typisk 1-2 minutters forsinkelse før de vises i dashboard.

</details>



## Oppgave 7 (ekstra-oppgave for de som vil teste, er i utgangspunktet neste ukes pensum): Implementering av AWS Lambda for periodiske oppgaver

I denne oppgaven skal du implementere en AWS Lambda-funksjon for å utføre periodiske oppgaver relatert til oppgavestyringssystemet.

Før man begynner på denne oppgaven må man legge inn eposten sin som `Verified Identity` i AWS SES (Simple Email Service). Her er guide på hvordan det gjøres:

1. Verifiser epost i SES:
    - Åpne AWS Console
    - Søk etter "SES" eller "Simple Email Service"
    - Velg din region (f.eks. "eu-west-1")
    - Klikk på "Verified identities"
    - Velg "Create identity"
    - Velg "Email address"
    - Skriv inn din epostadresse
    - Klikk "Create identity"
    - Sjekk innboksen din for verifiseringslink
    - Klikk på linken for å verifisere

> [!NOTE]
> For testing, gjenta prosessen over for mottaker-eposten også.

Nå har du muligheten til å sende epost gjennom AWS SES og kan gå videre med oppgaven under.

### Oppgavebeskrivelse

1. Opprett en IAM-rolle for Lambda-funksjonen med nødvendige tillatelser.
2. Opprett nødvendige Lambda Layers for eksterne biblioteker.
3. Skriv en Lambda-funksjon i Python som sjekker for forfallsdatoer på oppgaver og sender varslinger.
4. Konfigurer en CloudWatch Events regel for å kjøre Lambda-funksjonen daglig.
5. Test Lambda-funksjonen og verifiser at varslingene blir sendt.

Her er et eksempel på hvordan du kan sende epost via Python og AWS SES:

```python
import boto3

def send_email(subject, body, recipient):
    ses_client = boto3.client('ses', region_name='eu-west-1')  # Endre region etter behov
    
    try:
        response = ses_client.send_email(
            Source='din-verifiserte-epost@example.com',  # Må være verifisert i SES
            Destination={
                'ToAddresses': [recipient]  # Mottaker må være verifisert i sandbox mode
            },
            Message={
                'Subject': {
                    'Data': subject
                },
                'Body': {
                    'Text': {
                        'Data': body
                    }
                }
            }
        )
        return response['MessageId']
    except Exception as e:
        print(f"Error sending email: {str(e)}")
        raise e

# Eksempel på bruk:
# send_email("Test Subject", "Hello World!", "mottaker@example.com")
```

### Mermaid Diagram

```mermaid
graph TB
     CW[CloudWatch Event]
     Lambda[AWS Lambda]
     Layer[Lambda Layer]
     RDS[(RDS MySQL)]
     SES[Amazon SES]
     
     CW -->|Trigger daily| Lambda
     Layer -->|Provide dependencies| Lambda
     Lambda -->|Query tasks| RDS
     Lambda -->|Send notifications| SES
```

> [!IMPORTANT]
> AWS Lambda er en serverløs teknologi som lar deg kjøre kode uten å administrere servere. Ved å kombinere Lambda med CloudWatch Events, kan du enkelt sette opp periodiske oppgaver som kjører automatisk, noe som er ideelt for bakgrunnsjobber og vedlikeholdsoppgaver.


<details>
<summary>Løsning</summary>

1. Opprett en IAM-rolle for Lambda:
    - Gå til IAM i AWS Console
    - Klikk på \"Roles\" og deretter \"Create role\"
    - Velg AWS service og Lambda
    - Legg til følgende policies:
      - AWSLambdaBasicExecutionRole
      - AmazonRDSReadOnlyAccess
      - AmazonSESFullAccess

2. Opprett Lambda Layer for PyMySQL:
    - Opprett en ny mappe på din lokale maskin
    - Kjør følgende kommandoer:
    ```bash
    mkdir python
    pip install pymysql -t python/
    zip -r pymysql_layer.zip python/
    ```
    - Gå til Lambda i AWS Console
    - Velg "Layers" og "Create layer"
    - Last opp zip-filen
    - Velg kompatible runtime (Python 3.x)
    - Gi layer et navn (f.eks. "pymysql-layer")

3. Skriv Lambda-funksjonen:
    - Gå til Lambda i AWS Console
    - Klikk på "Create function"
    - Velg "Author from scratch"
    - Gi funksjonen et navn
    - Velg Python som runtime
    - Velg IAM-rollen du opprettet
    - Under "Layers", legg til layer du opprettet
    - Erstatt standardkoden med følgende:

```python
import boto3
import pymysql
import os
from datetime import datetime, timedelta

def lambda_handler(event, context):
     # Connect to RDS
     conn = pymysql.connect(
          host=os.environ['RDS_HOST'],
          user=os.environ['RDS_USER'],
          password=os.environ['RDS_PASSWORD'],
          db=os.environ['RDS_DB_NAME']
     )
     
     try:
          with conn.cursor() as cursor:
                # Check for tasks due in the next 24 hours
                tomorrow = datetime.now() + timedelta(days=1)
                cursor.execute("SELECT id, title, due_date FROM tasks WHERE due_date <= %s", (tomorrow,))
                due_tasks = cursor.fetchall()
                
                # Send notifications for due tasks
                ses = boto3.client('ses', region_name='us-west-2')  # Change region as needed
                for task in due_tasks:
                     subject = f"Task Due Soon: {task[1]}"
                     body = f"Your task '{task[1]}' is due on {task[2]}."
                     ses.send_email(
                          Source='your-email@example.com',
                          Destination={'ToAddresses': ['recipient@example.com']},
                          Message={
                                'Subject': {'Data': subject},
                                'Body': {'Text': {'Data': body}}
                          }
                     )
                     
                return f"Processed {len(due_tasks)} due tasks"
     finally:
          conn.close()
```

4. Konfigurer miljøvariabler:
    - I Lambda-funksjonen, gå til "Configuration" -> "Environment variables"
    - Legg til følgende variabler:
      - RDS_HOST: RDS-endepunkt
      - RDS_USER: Databasebrukernavn
      - RDS_PASSWORD: Databasepassord
      - RDS_DB_NAME: Databasenavn

5. Konfigurer CloudWatch Events:
    - I Lambda-funksjonen, gå til "Configuration" -> "Triggers"
    - Klikk på "Add trigger"
    - Velg "CloudWatch Events/EventBridge"
    - Opprett en ny regel:
      - Rule type: Schedule expression
      - Schedule expression: cron(0 0 * * ? *) (kjører hver dag kl. 00:00 UTC)
    - Klikk på "Add"

6. Test Lambda-funksjonen:
    - Klikk på "Test" i Lambda-konsollen
    - Opprett en testbegivenhet (kan være tom JSON: {})
    - Kjør testen og sjekk loggene for resultater

> [!NOTE]
> Hvis du får feilmeldinger relatert til manglende biblioteker, sjekk at Lambda Layer er korrekt konfigurert og at alle avhengigheter er inkludert i laget.

Du har nå implementert en Lambda-funksjon med nødvendige avhengigheter som automatisk sjekker for oppgaver som snart forfaller og sender varslinger.

</details>


# Sletting av ressurser i etterkant:

Resource Explorer klarer ikke alltid å finne RDS databaser, så disse må slettes manuelt. Dette gjøres ved å gå til RDS i konsollen, velge databasen og slette den.

