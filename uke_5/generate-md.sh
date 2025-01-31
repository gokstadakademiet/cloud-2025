#!/bin/bash

CURRENT_DIR="$(dirname "$0")"
SOURCE_DIR="$CURRENT_DIR/md/veiledet-oppgave" 
TARGET_FILE="ukesoppgaver.md"

echo "Generating markdown file from files in $SOURCE_DIR"

echo "# Oppgavesett: AWS - Cloudformation" > "$TARGET_FILE"

echo "# Innholdsfortegnelse

1. [Opprette grunnleggende nettverksinfrastruktur med CloudFormation](#oppgave-1-opprette-grunnleggende-nettverksinfrastruktur-med-cloudformation)
2. [Opprette en EC2-instans med CloudFormation](#oppgave-2-opprette-en-ec2-instans-med-cloudformation)
3. [Legge til en RDS-database med CloudFormation](#oppgave-3-legge-til-en-rds-database-med-cloudformation)
4. [Implementere Lambda-funksjon med CloudFormation](#oppgave-4-implementere-lambda-funksjon-med-cloudformation)
5. [Implementere SNS og SQS med CloudFormation](#oppgave-5-implementere-sns-og-sqs-med-cloudformation)
6. [Implementere CloudWatch Logs for Lambda-funksjoner](#oppgave-6-implementere-cloudwatch-logs-for-lambda-funksjoner)
" >> "$TARGET_FILE"

echo "# Introduksjon til skyteknologi med AWS: Oppgavestyringssystem

I dette kurset skal vi bygge et enkelt oppgavestyringssystem ved hjelp av AWS-tjenester. Vi vil starte med grunnleggende oppsett og gradvis bygge ut funksjonaliteten. Kurset vil fokusere på infrastruktur og AWS-tjenester, med minimal vekt på applikasjonskode.

> [!NOTE]
> **Før du begynner er det viktig at du setter deg inn i AWS Free Tier, se artikkel [her](../aws.md).**

> [!NOTE]
> **Hvis du bruker Windows er det lurt å laste ned Git Bash og bruke det som terminal for oppgavene, fremfor f.eks. PowerShell som er typisk på Windows. Du vil da kunne kjøre samme kommandoer som vist i ukesoppgavene Se video for hvordan Git Bash installeres [her](https://www.youtube.com/watch?v=qdwWe9COT9k).**
" >> "$TARGET_FILE"

for md_file in $(ls "$SOURCE_DIR"/*.md | sort); do
    sed 's/^[[:space:]]*>/>/' "$md_file" >> "$TARGET_FILE"
    echo "\n\n" >> "$TARGET_FILE"
done

echo "Fixing image paths..."
sed -i '' 's|\.\./\.\./\.\./static/img/|\.\./static/img/|g' "$TARGET_FILE"

echo "# Sletting av ressurser i etterkant:

Resource Explorer klarer ikke alltid å finne RDS databaser, så disse må slettes manuelt. Dette gjøres ved å gå til RDS i konsollen, velge databasen og slette den.
" >> "$TARGET_FILE"