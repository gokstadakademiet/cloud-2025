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
- Opprett en ny security group som tillater innkommende trafikk på port 22 (SSH) og 80 (HTTP)

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
5. Klikk på \"Create VPC\".

### 1b. Opprett en EC2-instans

1. Gå til EC2-konsollet i AWS.
2. Klikk på \"Launch instance\".
3. Velg Amazon Linux 2 AMI.
4. Velg t2.micro instanstype.
5. Konfigurer instansdetaljer:
   - Network: Velg den nyopprettede VPC-en
   - Subnet: Velg et av de offentlige subnettene
6. Konfigurer Security Group:
   - Opprett en ny security group
   - Legg til regel for SSH (port 22) og HTTP (port 80)
7. Gjennomgå og launch instansen.

### 1c. Opprett en S3-bucket

1. Gå til S3-konsollet i AWS.
2. Klikk på \"Create bucket\".
3. Velg et unikt navn for bucketen (f.eks. oppgavestyring-filer-\<ditt-navn\>).
4. La alle andre innstillinger være som standard.
5. Klikk på \"Create bucket\".

Du har nå satt opp grunnleggende infrastruktur for oppgavestyringssystemet vårt.

</details>

## Oppgave 2: Sett opp database

I denne oppgaven skal vi sette opp en MySQL-database ved hjelp av Amazon RDS for å lagre oppgaver og brukerinformasjon.

Opprett en Amazon RDS MySQL-instans med følgende spesifikasjoner:
- Engine: MySQL
- Instance class: db.t4g.micro (Free Tier eligible)
- Multi-AZ deployment: No
- Initial database name: taskmanager
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

> [!WARNING]
> Se bilde i steg 4. Default selektert RDS Database Instance size koster penger. Selekter `Free Tier` med `tb.t4g.micro`

![Screenshot of AWS RDS Free Tier](../../../static/img/rds-free-tier.png)

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

![Screenshot of AWS RDS Free Tier](../../../static/img/rds-create-popup.png)

Nå har du satt opp en MySQL-database og konfigurert sikkerhetsgrupper for å tillate tilkobling fra EC2-instansen.

> [!NOTE]
> Husk å lagre tilkoblingsinformasjonen for databasen (endpoint, brukernavn, passord) på et sikkert sted. Du vil trenge denne informasjonen senere når du skal koble applikasjonen til databasen.

</details>

## Oppgave 3: Sett opp backend-applikasjon

I denne oppgaven skal vi utvikle en Python-basert backend-applikasjon lokalt, containerize den med Docker, og kjøre den på EC2-instansen.

### 3a. Utvikle lokal applikasjon

1. Opprett en ny mappe for prosjektet:
```bash
mkdir taskmanager
cd taskmanager
```

2. Opprett `requirements.txt`:
```text
flask
flask-sqlalchemy
pymysql
```

3. Opprett `app.py` med samme innhold som før:
```python
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:your_password@your_rds_endpoint/taskmanager'
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
  db.create_all()
  app.run(host='0.0.0.0', port=80)
```

### 3b. Dockerize applikasjonen

1. Opprett `Dockerfile`:
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .
EXPOSE 80
CMD ["python", "app.py"]
```

2. Bygg og push Docker image:
```bash
docker build -t taskmanager .
docker tag taskmanager:latest your-docker-hub-username/taskmanager:latest
docker push your-docker-hub-username/taskmanager:latest
```

### 3c. Kjør på EC2

1. SSH til EC2-instansen:
```bash
ssh -i /path/to/your-key.pem ec2-user@your-ec2-public-ip
```

2. Installer Docker:
```bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
```

3. Pull og kjør container:
```bash
docker pull your-docker-hub-username/taskmanager:latest
docker run -d -p 80:80 your-docker-hub-username/taskmanager:latest
```

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
  Docker[Docker Container]
  App[Python Flask App]

  Internet --> IG
  IG --> VPC
  VPC --> PublicSubnet1
  VPC --> PublicSubnet2
  PublicSubnet1 --> EC2
  PublicSubnet2 --> RDS
  Internet --> S3
  EC2 --> Docker
  Docker --> App
  App --> RDS
```

<details>
<summary>Tips for feilsøking</summary>

1. Sjekk container logs:
```bash
docker logs $(docker ps -q)
```

2. Verifiser at container kjører:
```bash
docker ps
```

3. Test API-endepunktet:
```bash
curl http://localhost/tasks
```

</details>

## Oppgave 4: Implementer logging og overvåkning

I denne oppgaven skal vi implementere logging og overvåkning for vår backend-applikasjon ved hjelp av Amazon CloudWatch.

### 4a. Konfigurer CloudWatch Agent
- Installer CloudWatch Agent på EC2-instansen
- Opprett konfigurasjonsfil for CloudWatch Agent
- Konfigurer agenten til å samle CPU, minne og disk metrics
- Start CloudWatch Agent

### 4b. Modifiser Python-applikasjonen
- Legg til logging i Python-applikasjonen
- Konfigurer logging til å skrive til /var/log/taskmanager.log
- Implementer logging for alle API-kall

### 4c. Opprett CloudWatch Dashboard
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

### 4a. Konfigurer CloudWatch Agent

1. Koble til EC2-instansen og installer CloudWatch Agent:
```bash
sudo yum install amazon-cloudwatch-agent -y
```

2. Opprett konfigurasjonsfil:
```bash
sudo nano /opt/aws/amazon-cloudwatch-agent/bin/config.json
```

3. Legg inn følgende konfigurasjon:
```json
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
```

4. Start agenten:
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
```

### 4b. Modifiser Python-applikasjonen

1. Oppdater app.py med logging:
```python
import logging
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

logging.basicConfig(
  filename='/var/log/taskmanager.log',
  level=logging.INFO,
  format='%(asctime)s - %(levelname)s - %(message)s'
)

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:your_password@your_rds_endpoint/taskmanager'
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
  db.create_all()
  app.run(host='0.0.0.0', port=80)
```

### 4c. Opprett CloudWatch Dashboard

1. Gå til CloudWatch i AWS Console
2. Velg "Dashboards" → "Create dashboard"
3. Gi dashboardet navnet "TaskManager-Dashboard"
4. Legg til widgets:
   - CPU Utilization
   - Memory Usage
   - Disk Usage
   - Log widget for taskmanager-logs

### Verifisering

Test oppsett ved å kjøre:
```bash
# Sjekk logger
aws logs tail taskmanager-logs

# Test API med logging
curl -X POST -H "Content-Type: application/json" -d '{"title":"Test Task"}' http://localhost/tasks
```

</details>

## Oppgave 5: Custom CloudWatch Metrics

I denne oppgaven skal vi implementere custom metrics for å spore ytterligere detaljer om oppgavestyringssystemet vårt.

### 5a. Implementer Custom Metrics

Oppdater Python-applikasjonen for å inkludere custom metrics:

1. Legg til boto3 i requirements.txt: (TODO: ADD GIT DIFF)
```text
flask
flask-sqlalchemy
pymysql
boto3
```

2. Oppdater app.py med custom metrics: (TODO: ADD GIT DIFF)
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
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:your_password@your_rds_endpoint/taskmanager'
db = SQLAlchemy(app)
cloudwatch = boto3.client('cloudwatch')

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
```

### 5b. Konfigurer Dashboard

1. Gå til CloudWatch console
2. Opprett en ny widget i eksisterende dashboard
3. Legg til custom metric "TasksCreated" fra "TaskManagerMetrics" namespace

<details>
<summary>Løsning</summary>

1. Verifiser at EC2-instansen har riktige IAM-rettigheter:
- Gå til IAM console
- Opprett eller oppdater IAM role med følgende policy:
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

2. Test custom metrics:
```bash
curl -X POST -H "Content-Type: application/json" \
   -d '{"title":"Test Task","description":"Testing custom metrics"}' \
   http://localhost/tasks
```

3. Sjekk CloudWatch console for å verifisere at metrikkene blir registrert.

</details>
