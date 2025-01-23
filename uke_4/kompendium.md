# Uke 4: Serverless Computing med AWS Lambda, SNS og SQS

1. [Introduksjon til Serverless Computing](#1-introduksjon-til-serverless-computing)
   - [Hva er Serverless Computing?](#hva-er-serverless-computing)
   - [Fordeler med Serverless Computing](#fordeler-med-serverless-computing)
   - [Utfordringer med Serverless Computing](#utfordringer-med-serverless-computing)

2. [AWS Lambda](#2-aws-lambda)
   - [Hva er AWS Lambda?](#hva-er-aws-lambda)
   - [Hvordan fungerer AWS Lambda?](#hvordan-fungerer-aws-lambda)
   - [Lambda-funksjoner og triggere](#lambda-funksjoner-og-triggere)
   - [Beste praksiser for Lambda](#beste-praksiser-for-lambda)

3. [Amazon Simple Notification Service (SNS)](#3-amazon-simple-notification-service-sns)
   - [Hva er Amazon SNS?](#hva-er-amazon-sns)
   - [SNS-emner og abonnenter](#sns-emner-og-abonnenter)
   - [Bruksområder for SNS](#bruksområder-for-sns)

4. [Amazon Simple Queue Service (SQS)](#4-amazon-simple-queue-service-sqs)
   - [Hva er Amazon SQS?](#hva-er-amazon-sqs)
   - [SQS-køtyper](#sqs-køtyper)
   - [Meldingsbehandling i SQS](#meldingsbehandling-i-sqs)
   - [Bruksområder for SQS](#bruksområder-for-sqs)

5. [Integrering av Lambda, SNS og SQS](#5-integrering-av-lambda-sns-og-sqs)
   - [Lambda med SNS](#lambda-med-sns)
   - [Lambda med SQS](#lambda-med-sqs)
   - [Arkitekturmønstre](#arkitekturmønstre)

# 1. Introduksjon til Serverless Computing

## Hva er Serverless Computing?

Serverless computing er en cloud computing-modell der cloud-leverandøren automatisk håndterer infrastrukturen, skalering og ressursallokering. Utviklere kan fokusere på å skrive kode uten å bekymre seg for serveradministrasjon.

## Fordeler med Serverless Computing

- **Kostnadseffektivitet**: Du betaler kun for faktisk beregningsbruk.
- **Automatisk skalering**: Tjenesten skalerer automatisk basert på arbeidsmengde.
- **Redusert kompleksitet**: Mindre behov for infrastrukturhåndtering.
- **Raskere tid til marked**: Utviklere kan fokusere på applikasjonslogikk.

## Utfordringer med Serverless Computing

- **Cold starts**: Forsinkelser når funksjoner ikke har vært i bruk på en stund.
- **Begrenset kjøretid**: De fleste serverless-plattformer har tidsbegrensninger.
- **Debugging**: Det kan være utfordrende å feilsøke distribuerte serverless-applikasjoner.

> [!NOTE]
> Serverless betyr ikke \"ingen servere\", men at serverhåndteringen er abstrahert bort fra utvikleren.

# 2. AWS Lambda

## Hva er AWS Lambda?

AWS Lambda er en serverless compute-tjeneste som lar deg kjøre kode uten å provisjonere eller administrere servere. Lambda kjører koden din basert på hendelser og skalerer automatisk.

## Hvordan fungerer AWS Lambda?

1. Du laster opp din kode til Lambda.
2. Du setter opp triggere som aktiverer funksjonen.
3. Lambda kjører koden din når den utløses, og allokerer nødvendige ressurser.
4. Du betaler kun for beregningskraften som brukes.

## Lambda-funksjoner og triggere

Lambda-funksjoner er de grunnleggende enhetene i Lambda. De kan utløses av:

- API Gateway-forespørsler
- S3 bucket-hendelser
- DynamoDB-strømmer
- CloudWatch-hendelser
- SNS-meldinger
- SQS-køer

> [!TIP]
> Velg riktig trigger for ditt brukstilfelle for å optimalisere ytelsen og kostnadseffektiviteten.

## Beste praksiser for Lambda

- Hold funksjonene små og fokuserte.
- Minimer cold starts ved å holde funksjonene \"varme\".
- Bruk miljøvariabler for konfigurasjoner.
- Implementer feilhåndtering og logging.

# 3. Amazon Simple Notification Service (SNS)

## Hva er Amazon SNS?

Amazon SNS er en fullt administrert meldingstjeneste for både application-to-application (A2A) og application-to-person (A2P) kommunikasjon.

## SNS-emner og abonnenter

- **Emner**: Kommunikasjonkanaler for relaterte meldinger.
- **Abonnenter**: Endepunkter som mottar meldinger fra emner.

Abonnenter kan være:
- Lambda-funksjoner
- SQS-køer
- HTTP/HTTPS-endepunkter
- E-post
- SMS

## Bruksområder for SNS

- Hendelsesbaserte arkitekturer
- Mobilvarslinger
- Systemvarsler og overvåking
- Distribuert applikasjonskommunikasjon

> [!IMPORTANT]
> Sørg for å konfigurere riktige tillatelser i IAM for SNS-emner for å kontrollere hvem som kan publisere og abonnere.

# 4. Amazon Simple Queue Service (SQS)

## Hva er Amazon SQS?

Amazon SQS er en fullt administrert meldingskøtjeneste som gjør det enkelt å dekoble og skalere mikroservices, distribuerte systemer og serverless-applikasjoner.

## SQS-køtyper

1. **Standard køer**: 
   - Garanterer minst én levering
   - Høy gjennomstrømning
   - Meldinger kan leveres i en annen rekkefølge enn de ble sendt

2. **FIFO-køer (First-In-First-Out)**:
   - Garanterer nøyaktig én behandling
   - Meldinger behandles i den rekkefølgen de ble sendt

## Meldingsbehandling i SQS

1. En produsent sender en melding til køen.
2. En forbruker henter meldingen fra køen.
3. Meldingen blir usynlig i køen under behandling.
4. Etter vellykket behandling slettes meldingen fra køen.

## Bruksområder for SQS

- Lastbalansering av arbeidsmengder
- Buffering og batchbehandling
- Asynkron kommunikasjon mellom tjenester
- Håndtering av trafikktopper

> [!TIP]
> Bruk SQS Dead Letter Queues for å håndtere meldinger som ikke kan behandles.

# 5. Integrering av Lambda, SNS og SQS

## Lambda med SNS

Lambda kan abonnere på SNS-emner for å behandle meldinger:

1. Konfigurer en Lambda-funksjon.
2. Opprett et SNS-emne.
3. Konfigurer Lambda som abonnent på emnet.
4. Når en melding publiseres, utløses Lambda-funksjonen.

## Lambda med SQS

Lambda kan konsumere meldinger fra SQS-køer:

1. Opprett en SQS-kø.
2. Konfigurer en Lambda-funksjon.
3. Sett opp en trigger fra SQS til Lambda.
4. Lambda poller køen og behandler meldinger i batcher.

## Arkitekturmønstre

- **Fanout-mønster**: SNS distribuerer meldinger til flere SQS-køer.
- **Arbeider-mønster**: SQS brukes som en buffer, og Lambda-funksjoner behandler meldinger.
- **Hendelsesbasert arkitektur**: SNS utløser Lambda-funksjoner basert på hendelser.

> [!NOTE]
> Kombiner disse tjenestene for å bygge skalerbare, feiltolerante og løst koblede systemer.

Ved å forstå og bruke disse AWS-tjenestene effektivt, kan du bygge robuste, skalerbare og kostnadseffektive serverless-applikasjoner.
