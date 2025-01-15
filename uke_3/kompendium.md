# Uke 3: Introduksjon til AWS Grunnleggende Tjenester

1. [Introduksjon til AWS CLI](#1-introduksjon-til-aws-cli)
  - [Hva er AWS CLI?](#hva-er-aws-cli)
  - [Fordeler med AWS CLI](#fordeler-med-aws-cli)
  - [Installere AWS CLI](#installere-aws-cli)
  - [Grunnleggende AWS CLI-kommandoer](#grunnleggende-aws-cli-kommandoer)
2. [AWS CloudWatch](#2-aws-cloudwatch)
  - [Hva er AWS CloudWatch?](#hva-er-aws-cloudwatch)
  - [Hovedfunksjoner i CloudWatch](#hovedfunksjoner-i-cloudwatch)
  - [CloudWatch Metrics](#cloudwatch-metrics)
  - [CloudWatch Alarms](#cloudwatch-alarms)
3. [AWS Identity and Access Management (IAM)](#3-aws-identity-and-access-management-iam)
  - [Hva er IAM?](#hva-er-iam)
  - [IAM Users](#iam-users)
  - [IAM Roles](#iam-roles)
  - [IAM Policies](#iam-policies)
4. [Amazon Simple Storage Service (S3)](#4-amazon-simple-storage-service-s3)
  - [Hva er Amazon S3?](#hva-er-amazon-s3)
  - [S3 Buckets](#s3-buckets)
  - [S3 Storage Classes](#s3-storage-classes)
  - [S3 Security](#s3-security)
5. [Amazon Relational Database Service (RDS)](#5-amazon-relational-database-service-rds)
  - [Hva er Amazon RDS?](#hva-er-amazon-rds)
  - [Støttede databasemotorer](#støttede-databasemotorer)
  - [RDS Instances](#rds-instances)
  - [RDS Security](#rds-security)

# 1. Introduksjon til AWS CLI

## Hva er AWS CLI?

AWS Command Line Interface (CLI) er et verktøy som lar deg interagere med AWS-tjenester ved hjelp av kommandoer i kommandolinjen. Det gir direkte tilgang til de offentlige APIene til AWS-tjenester og lar deg utføre nesten alle operasjoner som er tilgjengelige i AWS Management Console.

## Fordeler med AWS CLI

- **Automatisering:** Muliggjør scripting av AWS-operasjoner for automatisering av oppgaver.
- **Effektivitet:** Raskere utførelse av oppgaver sammenlignet med å navigere gjennom konsollen.
- **Konsistens:** Gir konsistent grensesnitt på tvers av ulike operativsystemer.
- **Integrasjon:** Kan enkelt integreres med andre verktøy og systemer.

## Installere AWS CLI

For å installere AWS CLI, følg instruksjonene på [AWS sin offisielle nettside](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

## Eksempler på AWS CLI-kommandoer

- `aws configure`: Konfigurerer AWS CLI med din info.
- `aws s3 ls`: Lister opp S3-bøtter i din konto.
- `aws ec2 describe-instances`: Viser informasjon om EC2-instanser.
- `aws iam list-users`: Lister opp IAM-brukere i din konto.

# 2. AWS CloudWatch

## Hva er AWS CloudWatch?

AWS CloudWatch er en overvåkings- og observasjonstjeneste. Den gir data og praktisk innsikt for å overvåke applikasjoner, reagere på systemytelsesendringer og optimalisere ressursbruk.

## Hovedfunksjoner i CloudWatch

1. **Metrics:** Samler og sporer nøkkelmetrikker fra AWS-ressurser og applikasjoner.
2. **Alarms:** Setter opp varsler basert på definerte terskler.
3. **Logs:** Samler, overvåker og analyserer logger fra ulike kilder.
4. **Events:** Reagerer på endringer i AWS-ressurser i sanntid.

## CloudWatch Metrics

CloudWatch Metrics er datapunkter om ytelsen til dine systemer. Som standard tilbyr mange AWS-tjenester gratis metrikker for ressurser (som Amazon EC2 instances, Amazon EBS volumes, og Amazon RDS DB instances).

> [!IMPORTANT]
> Noen metrikker er bare tilgjengelige med detaljert overvåking, som kan medføre ekstra kostnader.

Eksempel på en metric: CPU-utnyttelse for en EC2-instans.

## CloudWatch Alarms

CloudWatch Alarms lar deg definere varsler basert på metrikker. Du kan for eksempel sette opp en alarm som sender en e-post når CPU-utnyttelsen på en EC2-instans overstiger 80% i mer enn 5 minutter.

```bash
aws cloudwatch put-metric-alarm \
    --alarm-name cpu-mon \
    --alarm-description \"Alarm when CPU exceeds 80 percent\" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --dimensions Name=InstanceId,Value=i-12345678 \
    --evaluation-periods 2 \
    --alarm-actions arn:aws:sns:us-east-1:111122223333:MyTopic
```

# 3. AWS Identity and Access Management (IAM)

## Hva er IAM?

AWS Identity and Access Management (IAM) er en webtjeneste som hjelper deg med å sikre kontroll over tilgang til AWS-ressurser. Du bruker IAM til å kontrollere hvem som er autentisert (innlogget) og autorisert (har tillatelser) til å bruke ressurser.

## IAM Users

IAM Users representerer personer eller tjenester som trenger tilgang til AWS-ressurser. Hver bruker har et unikt navn innenfor AWS-kontoen og et sett med security credentials.

## IAM Roles

IAM Roles er en sikker måte å gi tillatelser til enheter du stoler på. En IAM-rolle ligner på en bruker, ved at den er en AWS-identitet med tillatelsespolicyer som bestemmer hva identiteten kan og ikke kan gjøre i AWS.

## IAM Policies

IAM Policies er dokumenter som definerer tillatelser. Du kan tilknytte IAM Policies til IAM Users, Groups, eller Roles for å definere deres tilgangsnivå til AWS-ressurser.

Eksempel på en enkel IAM Policy som gir lesetilgang til en S3-bøtte:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::example-bucket",
                "arn:aws:s3:::example-bucket/*"
            ]
        }
    ]
}
```

# 4. Amazon Simple Storage Service (S3)

## Hva er Amazon S3?

Amazon Simple Storage Service (S3) er en objektlagringstjeneste med tilnærmet uendelig skalerbarhet, datatilgjengelighet, sikkerhet og ytelse. S3 er designet for å lagre og hente hvilken som helst mengde data fra hvor som helst.

## S3 Buckets

I S3 lagres data som objekter i beholdere kalt \"buckets\". Hver S3 bucket må ha et globalt unikt navn.

For å opprette en ny S3 bucket via AWS CLI:

```bash
aws s3 mb s3://my-unique-bucket-name
```

## S3 Storage Classes

S3 tilbyr flere lagringsklasser designet for forskjellige brukstilfeller:

1. **S3 Standard:** For generell lagring av hyppig brukte data.
2. **S3 Intelligent-Tiering:** Optimaliserer kostnader ved å flytte data automatisk mellom to tilgangsklasser.
3. **S3 Standard-IA (Infrequent Access):** For data som brukes sjeldnere, men krever rask tilgang.
4. **S3 One Zone-IA:** Lavere kostnad for sjeldent brukte data som ikke krever høy tilgjengelighet.
5. **S3 Glacier:** Lavkostnadslagring for arkivering og langtidsbackup.
6. **S3 Glacier Deep Archive:** Laveste kostnad for lagring av sjeldent brukte data med hentingstid på 12 timer.

## S3 Security

S3 tilbyr flere sikkerhetsfunksjoner:

- **Bucket Policies:** JSON-baserte dokumenter som spesifiserer hvem som har tilgang til bøtten og hvilke handlinger de kan utføre.
- **Access Control Lists (ACLs):** Kontrollerer tilgang til individuelle objekter i en bøtte.
- **Encryption:** S3 støtter både server-side og klient-side kryptering.

> [!WARNING]
> Vær forsiktig med å gjøre S3-bøtter offentlig tilgjengelige. Mange datasikkerhetsbrudd har skjedd på grunn av feilkonfigurerte S3-bøtter.

# 5. Amazon Relational Database Service (RDS)

## Hva er Amazon RDS?

Amazon Relational Database Service (RDS) gjør det enkelt å sette opp, operere og skalere en relasjonsdatabase i skyen. Det gir kostnadseffektiv og resizeable kapasitet samtidig som det håndterer tidkrevende databaseadministrasjonsoppgaver.

## Støttede databasemotorer

RDS støtter flere populære databasemotorer:

1. Amazon Aurora
2. PostgreSQL
3. MySQL
4. MariaDB
5. Oracle Database
6. SQL Server

## RDS Instances

En Amazon RDS-instans er en isolert database-miljø i skyen. Du kan ha flere instanser som kjører forskjellige versjoner av samme databasemotor.

For å opprette en ny RDS-instans via AWS CLI:

```bash
aws rds create-db-instance \
    --db-instance-identifier mydbinstance \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password secret99 \
    --allocated-storage 20
```

## RDS Security

RDS tilbyr flere sikkerhetsfunksjoner:

- **Encryption at rest:** Krypterer databasen og loggene ved hjelp av AWS Key Management Service (KMS).
- **Encryption in transit:** Bruker SSL for å sikre tilkoblinger til databasen.
- **Network Isolation:** Du kan kjøre RDS-instanser i en Amazon Virtual Private Cloud (VPC) for å isolere dem fra andre nettverk.

> [!TIP]
> Alltid bruk sterke passord og begrens nettverkstilgangen til dine RDS-instanser ved hjelp av sikkerhetsgruppeinnstillinger.

**Kilder:**

- [AWS Command Line Interface Documentation](https://docs.aws.amazon.com/cli/)
- [Amazon CloudWatch Documentation](https://docs.aws.amazon.com/cloudwatch/)
- [AWS Identity and Access Management Documentation](https://docs.aws.amazon.com/iam/)
- [Amazon S3 Documentation](https://docs.aws.amazon.com/s3/)
- [Amazon RDS Documentation](https://docs.aws.amazon.com/rds/)
