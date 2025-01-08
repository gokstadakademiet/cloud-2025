# Uke 2: Introduksjon til Amazon Web Services (AWS)

1. [Introduksjon til AWS](#1-introduksjon-til-aws)
   - [Hva er AWS?](#hva-er-aws)
   - [Fordeler med AWS](#fordeler-med-aws)
   - [AWS Management Console](#aws-management-console)
   - [Grunnleggende AWS-begreper](#grunnleggende-aws-begreper)
2. [Amazon Virtual Private Cloud (VPC)](#2-amazon-virtual-private-cloud-vpc)
   - [Hva er Amazon VPC?](#hva-er-amazon-vpc)
   - [Komponenter i en VPC](#komponenter-i-en-vpc)
   - [Nøkkelbegreper i VPC](#nøkkelbegreper-i-vpc)
   - [Sikkerhet i VPC](#sikkerhet-i-vpc)
3. [Amazon Elastic Compute Cloud (EC2)](#3-amazon-elastic-compute-cloud-ec2)
   - [Hva er Amazon EC2?](#hva-er-amazon-ec2)
   - [EC2 Instance Types](#ec2-instance-types)
   - [Amazon Machine Images (AMIs)](#amazon-machine-images-amis)
   - [EC2 Pricing Models](#ec2-pricing-models)
   - [Security Groups i EC2](#security-groups-i-ec2)
   - [Elastic Load Balancing (ELB)](#elastic-load-balancing-elb)
   - [Auto Scaling Groups (ASG)](#auto-scaling-groups-asg)
   - [EC2 Storage Options](#ec2-storage-options)
   - [Networking for EC2](#networking-for-ec2)
   - [Monitoring and Observability](#monitoring-and-observability)
     - [Amazon CloudWatch](#amazon-cloudwatch)
     - [CloudWatch Alarms](#cloudwatch-alarms)
     - [AWS Health Dashboard](#aws-health-dashboard)
4. [Amazon Elastic Container Service (ECS)](#4-amazon-elastic-container-service-ecs)
   - [Hva er Amazon ECS?](#hva-er-amazon-ecs)
   - [Hovedkomponenter i ECS](#hovedkomponenter-i-ecs)
   - [ECS og Docker Integrasjon](#ecs-og-docker-integrasjon)
   - [Deployment Strategier](#deployment-strategier)
   - [ECS Launch Types](#ecs-launch-types)
   - [Integrering med AWS-tjenester](#integrering-med-aws-tjenester)

# **1. Introduksjon til AWS**

## Hva er AWS?

Amazon Web Services (AWS) er en omfattende og bredt anvendt skyplattform som tilbyr over 200 fullfunksjonelle tjenester fra datasentre over hele verden. AWS leverer on-demand computing ressurser, databaser, storage, og andre IT-ressurser via internett med pay-as-you-go prising.

## Fordeler med AWS

- **Skalerbarhet:** Øk eller reduser ressurser basert på behov.
- **Kostnadseffektivitet:** Betal kun for det du bruker.
- **Pålitelighet:** AWS er bygget for høy tilgjengelighet og feiltoleranse.
- **Sikkerhet:** Omfattende sikkerhetsverktøy og best practices.

## AWS Management Console

AWS Management Console er et nettbasert grensesnitt for å få tilgang til og administrere AWS-tjenester. Det gir en intuitiv måte å interagere med AWS-ressurser på.

> [!TIP]
> Bruk søkefeltet i AWS Console for raskt å finne tjenester og ressurser.

## Grunnleggende AWS-begreper

- **Region:** Geografisk område som inneholder flere Availability Zones.
- **Availability Zone (AZ):** Et eller flere diskrete datasentre med redundant strøm, nettverk og tilkobling.
- **Edge Location:** Distribusjonspunkt for AWS CloudFront, Amazon's CDN-tjeneste.

# **2. Amazon Virtual Private Cloud (VPC)**

## Hva er Amazon VPC?

Amazon Virtual Private Cloud (VPC) lar deg provisjonere et logisk isolert avsnitt av AWS Cloud der du kan lansere AWS-ressurser i et virtuelt nettverk som du definerer.

## Komponenter i en VPC

- **Subnets:** Segmenter av IP-adresseområder i VPC.
- **Route Tables:** Sett av regler som bestemmer hvor nettverkstrafikk er dirigert.
- **Internet Gateway:** Tillater kommunikasjon mellom VPC og internett.
- **NAT Gateway:** Lar instanser i private subnets få tilgang til internett.

## Nøkkelbegreper i VPC

- **CIDR Block:** IP-adresseområde for VPC og subnets.
- **Elastic IP:** Statisk, offentlig IPv4-adresse.
- **VPC Peering:** Nettverksforbindelse mellom to VPCs.

> [!IMPORTANT]
> Planlegg IP-adresseområdet nøye når du oppretter en VPC, da dette ikke kan endres senere.

## Sikkerhet i VPC

- **Security Groups:** Virtuelle brannmurer for EC2-instanser.
- **Network Access Control Lists (NACLs):** Ekstra lag av sikkerhet på subnet-nivå.
- **Flow Logs:** Fanger informasjon om IP-trafikk som går til og fra nettverksgrensesnitt.

# **3. Amazon Elastic Compute Cloud (EC2)**

## Hva er Amazon EC2?

Amazon Elastic Compute Cloud (EC2) er en sentral del av Amazon's cloud computing-plattform, som tilbyr skalerbar beregningskapasitet i skyen. EC2 eliminerer behovet for å investere i maskinvare på forhånd, slik at du kan utvikle og distribuere applikasjoner raskere.

## EC2 Instance Types

EC2 tilbyr en rekke instanstyper optimalisert for ulike brukstilfeller:

- **General Purpose:** Balansert ytelse for en rekke arbeidsbelastninger.
- **Compute Optimized:** Ideell for beregningsintensive oppgaver.
- **Memory Optimized:** Designet for minneintensive arbeidsbelastninger.
- **Storage Optimized:** For arbeidsbelastninger som krever høy, sekvensiell lese-/skrivetilgang.

> [!TIP]
> Velg riktig instanstype basert på applikasjonens behov for å optimalisere ytelse og kostnader.

## Amazon Machine Images (AMIs)

En Amazon Machine Image (AMI) gir informasjonen som kreves for å lansere en instans. Den inkluderer:

- Et template for root volume (f.eks. et operativsystem)
- Launch permissions
- Block device mapping

## EC2 Pricing Models

AWS tilbyr flere prismodeller for EC2:

- **On-Demand Instances:** Betal for beregningskapasitet per time eller sekund.
- **Reserved Instances:** Forhåndsbetal for instanser og få betydelige rabatter.
- **Spot Instances:** Be om ledig EC2-kapasitet for opptil 90% rabatt sammenlignet med On-Demand priser.

> [!CAUTION]
> Spot Instances kan avsluttes med kort varsel. Bruk dem for feiltolerante og fleksible arbeidsbelastninger.

## Security Groups i EC2

Security Groups fungerer som virtuelle brannmurer for EC2-instanser:

- **Stateful:** Hvis en forespørsel er tillatt inn, er svaret automatisk tillatt ut
- **Tillatelses-basert:** Kun tillatte regler, ingen eksplisitte nektelser
- **Instance-level:** Opererer på instansnivå, ikke subnet-nivå

## Elastic Load Balancing (ELB)

AWS tilbyr flere typer load balancers:

- **Application Load Balancer (ALB):** For HTTP/HTTPS trafikk
- **Network Load Balancer (NLB):** For TCP/UDP trafikk
- **Classic Load Balancer:** Legacy load balancer (ikke anbefalt for nye applikasjoner)

> [!NOTE]
> Load balancers er kritiske for høy tilgjengelighet og feiltoleranse i distribuerte systemer.

## Auto Scaling Groups (ASG)

Auto Scaling Groups lar deg automatisk skalere EC2-instanser:

- **Dynamisk skalering:** Basert på metrics som CPU-bruk
- **Scheduled scaling:** Planlagt skalering basert på kjente bruksmønstre
- **Predictive scaling:** Bruker machine learning for å forutse kapasitetsbehov

## EC2 Storage Options

EC2 instanser kan bruke flere lagringsalternativer:

- **Instance Store:** Temporær blokklagring
- **EBS Volumes:** Persistent blokklagring
- **EFS:** Skalerbar fillagring for Linux-instanser

## Networking for EC2

Nettverkskonfigurasjon for EC2 inkluderer:

- **Elastic Network Interfaces (ENI):** Virtuelle nettverkskort
- **Enhanced Networking:** Høyere I/O ytelse og lavere CPU-bruk
- **Elastic IP:** Statiske, offentlige IPv4-adresser

## Monitoring and Observability

AWS tilbyr flere verktøy for monitorering og observabilitet:

### Amazon CloudWatch

CloudWatch er AWS' primære monitoreringsløsning:

- **Metrics:** Samler og sporer nøkkeltall
- **Logs:** Sentralisert logging
- **Events:** Reagerer på endringer i AWS-ressurser
- **Dashboards:** Visualisering av metrics og alarmer

### CloudWatch Alarms

Alarmer overvåker metrics og utløser actions:

- **Simple:** Basert på en enkelt metric
- **Composite:** Kombinerer flere metrics
- **Anomaly Detection:** Bruker ML for å oppdage unormale mønstre

> [!TIP]
> Sett opp alarmer for kritiske metrics som CPU-bruk og disk space.

### AWS Health Dashboard

- Viser status for AWS-tjenester
- Personlige varsler om hendelser som påvirker dine ressurser
- Planlagt vedlikehold og service health history

# **4. Amazon Elastic Container Service (ECS)**

## Hva er Amazon ECS?

Amazon Elastic Container Service (ECS) er en fullstendig administrert containertjeneste som gjør det enkelt å kjøre, stoppe og administrere Docker-containere på en klynge av EC2-instanser.

## Hovedkomponenter i ECS

- **Task Definitions:** Blueprint for applikasjonen (Docker container konfigurasjon)
- **Tasks:** Instans av en Task Definition som kjører på en container-instans
- **Services:** Sikrer at et spesifisert antall tasks kjører samtidig
- **Clusters:** Logisk gruppering av EC2-instanser som kjører ECS container agent

## ECS og Docker Integrasjon

ECS jobber sømløst med Docker:

- **Docker Images:** Lagres i Amazon Elastic Container Registry (ECR)
- **Docker Compose:** Støtter import av Docker Compose filer
- **Docker CLI:** Kan brukes sammen med ECS CLI

> [!TIP]
> Bruk ECR for sikker lagring og distribusjon av Docker images.

## Deployment Strategier

- **Rolling Updates:** Gradvis oppdatering av containere
- **Blue/Green Deployment:** Null nedetid ved oppdateringer
- **Capacity Providers:** Automatisk skalering av underlying infrastructure

## ECS Launch Types

- **EC2 Launch Type:** Kjører containere på administrerte EC2-instanser
- **Fargate Launch Type:** Serverless compute for containere

> [!NOTE]
> Fargate eliminerer behovet for å administrere underliggende server-infrastruktur.

## Integrering med AWS-tjenester

ECS integrerer sømløst med:
- Application Load Balancer for trafikk-distribusjon
- CloudWatch for logging og monitorering
- IAM for sikkerhet og tilgangskontroll
- VPC for nettverksisolasjon