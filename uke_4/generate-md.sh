#!/bin/bash

CURRENT_DIR="$(dirname "$0")"
SOURCE_DIR="$CURRENT_DIR/md/veiledet-oppgave" 
TARGET_FILE="ukesoppgaver.md"

echo "Generating markdown file from files in $SOURCE_DIR"

echo "# Oppgavesett: AWS - Lambda, SQS og SNS" > "$TARGET_FILE"

echo "# Innholdsfortegnelse

1. [Oppsett av grunnleggende infrastruktur](#oppgave-1-oppsett-av-grunnleggende-infrastruktur)
2. [Implementer backend-logikk med AWS Lambda](#oppgave-2-implementer-backend-logikk-med-aws-lambda)
3. [Implementer meldingskø med SQS og SNS](#oppgave-3-implementer-meldingskø-med-sqs-og-sns)
4. [Implementer en enkel frontend på EC2](#oppgave-4-implementer-en-enkel-frontend-på-ec2)
5. [Implementer logging og overvåking med CloudWatch](#oppgave-5-implementer-logging-og-overvåking-med-cloudwatch)
6. [Sletting av ressurser i etterkant](#sletting-av-ressurser-i-etterkant)
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