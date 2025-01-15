## Oppgave 5: Implementer autentisering og autorisasjon

I denne oppgaven skal vi implementere en enkel autentiserings- og autorisasjonsmekanisme for vårt oppgavestyringssystem ved hjelp av AWS IAM og vår Python-applikasjon.

### 5a. Opprett IAM-brukere

Opprett to IAM-brukere med følgende spesifikasjoner:
- En bruker med full tilgang til oppgavestyringssystemet
- En bruker med kun lesetilgang til oppgavestyringssystemet

### 5b. Implementer token-basert autentisering

Utvid Python-applikasjonen for å støtte token-basert autentisering ved hjelp av JWT (JSON Web Tokens).

### 5c. Implementer rollebasert tilgangskontroll

Implementer rollebasert tilgangskontroll i Python-applikasjonen basert på IAM-brukerens rettigheter.

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
    App[Python Flask App]
    CloudWatch[CloudWatch]
    IAM[IAM]

    Internet --> IG
    IG --> VPC
    VPC --> PublicSubnet1
    VPC --> PublicSubnet2
    PublicSubnet1 --> EC2
    PublicSubnet2 --> RDS
    Internet --> S3
    EC2 --> App
    App --> RDS
    EC2 --> CloudWatch
    App --> IAM
```

<details>
<summary>Løsning</summary>

### 5a. Opprett IAM-brukere

1. Gå til IAM-konsollet i AWS.
2. Klikk på \"Users\" i sidemenyen og deretter \"Add user\".
3. For den første brukeren:
   - Brukernavn: taskmanager-admin
   - Access type: Programmatic access
4. Klikk \"Next: Permissions\
5. Velg \"Attach existing policies directly\" og søk etter og velg \"AmazonRDSFullAccess\" og \"AmazonEC2FullAccess\".
6. Fullfør opprettelsen av brukeren.
7. Gå deretter inn på denne brukeren i IAM, og scroll ned til du kommer `Access Keys`. Opprett en access key med `Create access key` -> `Application running on an AWS compute service`

 og lagre Access Key ID og Secret Access Key.
7. Gjenta prosessen for den andre brukeren:
   - Brukernavn: taskmanager-reader
   - Access type: Programmatic access
   - Tilordne en egendefinert policy med følgende JSON:

```json
{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Effect\": \"Allow\",
            \"Action\": [
                \"rds:DescribeDBInstances\",
                \"ec2:DescribeInstances\
            ],
            \"Resource\": \"*\
        }
    ]
}
```

### 5b. Implementer token-basert autentisering

1. Installer nødvendige biblioteker på EC2-instansen:

```bash
sudo pip3 install pyjwt
```

2. Oppdater `app.py` med følgende kode:

```python
import jwt
import datetime
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from functools import wraps

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:your_password@your_rds_endpoint/taskmanager'
app.config['SECRET_KEY'] = 'your_secret_key'  # Endre dette til en sikker nøkkel
db = SQLAlchemy(app)

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(200))
    status = db.Column(db.String(20), default='To Do')

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'message': 'Token is missing!'}), 401
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=[\"HS256\"])
        except:
            return jsonify({'message': 'Token is invalid!'}), 401
        return f(*args, **kwargs)
    return decorated

@app.route('/login', methods=['POST'])
def login():
    auth = request.authorization
    if auth and auth.username == 'admin' and auth.password == 'password':
        token = jwt.encode({'user': auth.username, 'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=30)},
                           app.config['SECRET_KEY'], algorithm=\"HS256\")
        return jsonify({'token': token})
    return jsonify({'message': 'Could not verify!'}), 401

@app.route('/tasks', methods=['GET'])
@token_required
def get_tasks():
    tasks = Task.query.all()
    return jsonify([{'id': task.id, 'title': task.title, 'description': task.description, 'status': task.status} for task in tasks])

@app.route('/tasks', methods=['POST'])
@token_required
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

### 5c. Implementer rollebasert tilgangskontroll

For å implementere rollebasert tilgangskontroll, må vi utvide vår autentiseringsmekanisme til å inkludere brukerroller. Vi kan gjøre dette ved å legge til en rolle i JWT-tokenet når en bruker logger inn.

1. Oppdater `app.py` med følgende endringer:

```python
import boto3

# ... (behold eksisterende imports og konfigurasjoner)

def get_aws_role(access_key, secret_key):
    iam = boto3.client('iam', aws_access_key_id=access_key, aws_secret_access_key=secret_key)
    try:
        user = iam.get_user()
        user_policies = iam.list_attached_user_policies(UserName=user['User']['UserName'])
        for policy in user_policies['AttachedPolicies']:
            if policy['PolicyName'] == 'AmazonRDSFullAccess':
                return 'admin'
        return 'reader'
    except:
        return None

@app.route('/login', methods=['POST'])
def login():
    auth = request.authorization
    if not auth:
        return jsonify({'message': 'Authentication required!'}), 401
    
    role = get_aws_role(auth.username, auth.password)
    if role:
        token = jwt.encode({
            'user': auth.username,
            'role': role,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=30)
        }, app.config['SECRET_KEY'], algorithm=\"HS256\")
        return jsonify({'token': token})
    return jsonify({'message': 'Could not verify!'}), 401

def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'message': 'Token is missing!'}), 401
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=[\"HS256\"])
            if data['role'] != 'admin':
                return jsonify({'message': 'Admin privileges required!'}), 403
        except:
            return jsonify({'message': 'Token is invalid!'}), 401
        return f(*args, **kwargs)
    return decorated

@app.route('/tasks', methods=['GET'])
@token_required
def get_tasks():
    tasks = Task.query.all()
    return jsonify([{'id': task.id, 'title': task.title, 'description': task.description, 'status': task.status} for task in tasks])

@app.route('/tasks', methods=['POST'])
@admin_required
def create_task():
    data = request.json
    new_task = Task(title=data['title'], description=data.get('description', ''))
    db.session.add(new_task)
    db.session.commit()
    return jsonify({'id': new_task.id, 'title': new_task.title, 'description': new_task.description, 'status': new_task.status}), 201
```

Denne implementasjonen bruker IAM-brukerens tilgangsnøkler for å bestemme deres rolle i systemet. Admin-brukere har full tilgang, mens leser-brukere kun har lesetilgang.

> [!NOTE]
> I en produksjonssetting bør du implementere mer robuste sikkerhetsmekanismer, som for eksempel å bruke AWS Cognito for brukerautentisering og autorisasjon, eller implementere en mer omfattende rollebasert tilgangskontroll.

Husk å installere boto3-biblioteket på EC2-instansen:

```bash
sudo pip3 install boto3
```

Nå har du implementert grunnleggende autentisering og autorisasjon for ditt oppgavestyringssystem!

</details>

## Oppgave 6: Implementer frontend-applikasjon

I denne oppgaven skal vi utvikle en enkel frontend-applikasjon for oppgavestyringssystemet vårt og lagre den i S3-bucketen vi opprettet tidligere.

### 6a. Utvikle en enkel HTML/JavaScript-applikasjon

Lag en enkel HTML-side med JavaScript som interagerer med backend-API-et.

### 6b. Last opp frontend-filer til S3

Last opp de utviklede frontend-filene til S3-bucketen.

### 6c. Konfigurer S3 for statisk webhosting

Konfigurer S3-bucketen for å fungere som en statisk webhost.

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
    App[Python Flask App]
    CloudWatch[CloudWatch]
    IAM[IAM]
    Frontend[Frontend HTML/JS]

    Internet --> IG
    IG --> VPC
    VPC --> PublicSubnet1
    VPC --> PublicSubnet2
    PublicSubnet1 --> EC2
    PublicSubnet2 --> RDS
    Internet --> S3
    EC2 --> App
    App --> RDS
    EC2 --> CloudWatch
    RDS --> CloudWatch
    App --> IAM
    S3 --> Frontend
    Frontend --> App
```

<details>
<summary>Løsning</summary>

### 6a. Utvikle en enkel HTML/JavaScript-applikasjon

Lag en fil kalt `index.html` med følgende innhold:

```html
<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Task Manager</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { text-align: center; }
        #taskList { list-style-type: none; padding: 0; }
        #taskList li { background-color: #f0f0f0; margin: 10px 0; padding: 10px; border-radius: 5px; }
        #newTaskForm { display: flex; margin-bottom: 20px; }
        #newTaskForm input { flex-grow: 1; margin-right: 10px; }
    </style>
</head>
<body>
    <h1>Task Manager</h1>
    <div id=\"loginForm\">
        <input type=\"text\" id=\"username\" placeholder=\"Username\">
        <input type=\"password\" id=\"password\" placeholder=\"Password\">
        <button onclick=\"login()\">Login</button>
    </div>
    <div id=\"taskManager\" style=\"display:none;\">
        <form id=\"newTaskForm\">
            <input type=\"text\" id=\"newTaskTitle\" placeholder=\"New task title\" required>
            <input type=\"text\" id=\"newTaskDescription\" placeholder=\"Description\">
            <button type=\"submit\">Add Task</button>
        </form>
        <ul id=\"taskList\"></ul>
    </div>
    <script>
        let token = '';
        const apiUrl = 'http://your-ec2-public-ip'; // Replace with your EC2 instance's public IP or domain

        async function login() {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            try {
                const response = await fetch(`${apiUrl}/login`, {
                    method: 'POST',
                    headers: {
                        'Authorization': 'Basic ' + btoa(username + \":\" + password)
                    }
                });
                const data = await response.json();
                if (data.token) {
                    token = data.token;
                    document.getElementById('loginForm').style.display = 'none';
                    document.getElementById('taskManager').style.display = 'block';
                    fetchTasks();
                } else {
                    alert('Login failed');
                }
            } catch (error) {
                console.error('Error:', error);
            }
        }

        async function fetchTasks() {
            try {
                const response = await fetch(`${apiUrl}/tasks`, {
                    headers: {
                        'Authorization': token
                    }
                });
                const tasks = await response.json();
                const taskList = document.getElementById('taskList');
                taskList.innerHTML = '';
                tasks.forEach(task => {
                    const li = document.createElement('li');
                    li.textContent = `${task.title}: ${task.description} (${task.status})`;
                    taskList.appendChild(li);
                });
            } catch (error) {
                console.error('Error:', error);
            }
        }

        document.getElementById('newTaskForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const title = document.getElementById('newTaskTitle').value;
            const description = document.getElementById('newTaskDescription').value;
            try {
                const response = await fetch(`${apiUrl}/tasks`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': token
                    },
                    body: JSON.stringify({ title, description })
                });
                if (response.ok) {
                    fetchTasks();
                    document.getElementById('newTaskTitle').value = '';
                    document.getElementById('newTaskDescription').value = '';
                } else {
                    alert('Failed to add task');
                }
            } catch (error) {
                console.error('Error:', error);
            }
        });
    
