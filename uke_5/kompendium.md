# Uke 1: AWS CloudFormation

1. [Infrastruktur som kode (IaC)](#infrastruktur-som-kode-iac)
  - [Hva er Infrastruktur som kode?](#hva-er-infrastruktur-som-kode)
  - [Fordeler med IaC](#fordeler-med-iac)
  - [Beste praksis for IaC](#beste-praksis-for-iac)
2. [Introduksjon til AWS CloudFormation](#introduksjon-til-aws-cloudformation)
  - [Hva er AWS CloudFormation?](#hva-er-aws-cloudformation)
  - [Fordeler med AWS CloudFormation](#fordeler-med-aws-cloudformation)
  - [Grunnleggende CloudFormation-konsepter](#grunnleggende-cloudformation-konsepter)
3. [CloudFormation Templates](#cloudformation-templates)
  - [Hva er en CloudFormation Template?](#hva-er-en-cloudformation-template)
  - [Template-struktur](#template-struktur)
  - [Ressursdeklarasjoner](#ressursdeklarasjoner)
4. [CloudFormation Stacks](#cloudformation-stacks)
  - [Hva er en CloudFormation Stack?](#hva-er-en-cloudformation-stack)
  - [Opprette og administrere Stacks](#opprette-og-administrere-stacks)
  - [Stack-oppdateringer og -sletting](#stack-oppdateringer-og--sletting)

# **1. Infrastruktur som kode (IaC)**

## Hva er Infrastruktur som kode?

Infrastruktur som kode (IaC) er en praksis der infrastruktur håndteres og provisjoneres gjennom kode istedenfor manuelle prosesser. Dette betyr at servere, databaser, nettverk og andre infrastrukturelementer defineres gjennom konfigurasjonsfiler.

## Fordeler med IaC

1. **Konsistens:** Eliminerer menneskelige feil og sikrer identisk oppsett hver gang
2. **Versjonskontroll:** Infrastrukturendringer kan spores og rulles tilbake
3. **Automatisering:** Reduserer manuelt arbeid og øker effektiviteten
4. **Dokumentasjon:** Koden selv fungerer som dokumentasjon
5. **Skalerbarhet:** Enkelt å reprodusere miljøer og skalere infrastruktur

## Beste praksis for IaC

- **Idempotens:** Samme kode skal gi samme resultat uansett hvor mange ganger den kjøres
- **Versjonskontroll:** Bruk Git eller lignende systemer for å spore endringer
- **Modularisering:** Del opp infrastrukturen i gjenbrukbare komponenter
- **Testing:** Test infrastrukturkoden før den implementeres i produksjon
- **Sikkerhet:** Implementer sikkerhet direkte i koden

> [!NOTE]
> IaC er grunnlaget for moderne DevOps-praksis og muliggjør kontinuerlig leveranse av infrastruktur.

# **2. Introduksjon til AWS CloudFormation**

## Hva er AWS CloudFormation?

AWS CloudFormation er en tjeneste som hjelper deg med å modellere og sette opp AWS-ressurser slik at du kan bruke mindre tid på å administrere disse ressursene og mer tid på å fokusere på applikasjonene dine som kjører i AWS. Du oppretter en mal som beskriver alle AWS-ressursene du ønsker (for eksempel Amazon EC2-instanser eller Amazon RDS DB-instanser), og CloudFormation tar seg av provisjonering og konfigurering av disse ressursene for deg.

## Fordeler med AWS CloudFormation

- **Infrastruktur som kode:** Du kan beskrive hele infrastrukturen din i en tekstfil, noe som gjør det enkelt å versjonskontrollere og gjenbruke.
- **Automatisering:** CloudFormation automatiserer oppsettet av infrastrukturen din, noe som reduserer menneskelige feil og sparer tid.
- **Repeterbarhet:** Du kan bruke samme mal til å opprette identiske miljøer for utvikling, testing og produksjon.
- **Kostnadseffektivitet:** Du kan enkelt opprette og slette hele stack av ressurser, noe som er nyttig for midlertidige miljøer.

## Grunnleggende CloudFormation-konsepter

1. **Templates:** JSON- eller YAML-filer som beskriver AWS-ressursene.
2. **Stacks:** En samling av AWS-ressurser som du administrerer som en enhet.
3. **Change Sets:** En oppsummering av foreslåtte endringer til en stack som lar deg se hvordan endringer kan påvirke dine kjørende ressurser.

> [!TIP]
> Bruk YAML for dine CloudFormation-templates. Det er mer lesbart og tillater kommentarer, noe som gjør det enklere å vedlikeholde over tid.

# **3. CloudFormation Templates**

## Hva er en CloudFormation Template?

En CloudFormation-template er en deklarativ beskrivelse av AWS-ressurser i JSON- eller YAML-format. Den definerer hva som skal opprettes og hvordan disse ressursene skal konfigureres.

## Template-struktur

En grunnleggende CloudFormation-template inneholder følgende seksjoner:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'A sample template'

Parameters:
  # Input parameters for your template

Resources:
  # The AWS resources you want to create

Outputs:
  # Values that are returned after stack creation
```

## Ressursdeklarasjoner

Ressurser er kjernen i din CloudFormation-template. Her er et eksempel på hvordan du kan deklarere en Amazon S3 Bucket:

```yaml
Resources:
  MyS3Bucket:
   Type: 'AWS::S3::Bucket'
   Properties:
    BucketName: my-unique-bucket-name
```

> [!IMPORTANT]
> Ressursnavn må være unike innenfor en template. Sørg for å gi beskrivende navn til ressursene dine for enklere vedlikehold.

# **4. CloudFormation Stacks**

## Hva er en CloudFormation Stack?

En CloudFormation Stack er en samling av AWS-ressurser som du kan administrere som en enkelt enhet. Alle ressursene i en stack opprettes basert på CloudFormation-templaten.

## Opprette og administrere Stacks

Du kan opprette en stack ved å sende inn en template til CloudFormation gjennom AWS Management Console, AWS CLI, eller AWS SDKs. CloudFormation leser templaten og gjør de nødvendige API-kallene for å opprette ressursene du har definert.

> [!CAUTION]
> Vær forsiktig når du oppretter stacks i produksjonsmiljøer. Bruk alltid Change Sets for å se forventede endringer før du anvender dem.

## Stack-oppdateringer og -sletting

- **Oppdateringer:** Du kan oppdatere en stack ved å endre templaten og sende den inn på nytt. CloudFormation vil da oppdatere eksisterende ressurser eller opprette nye basert på endringene.

- **Sletting:** Når du sletter en stack, sletter CloudFormation som standard alle ressursene som ble opprettet som en del av stacken.

> [!TIP]
> Bruk Stack Policies for å forhindre utilsiktet modifikasjon eller sletting av kritiske ressurser i en stack.

**Kilder:**

- [AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
- [AWS CloudFormation Best Practices](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html)

