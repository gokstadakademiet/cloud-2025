#!/bin/bash

CURRENT_DIR="$(dirname "$0")"
SOURCE_DIR="$CURRENT_DIR/md/veiledet-oppgave" 
TARGET_FILE="ukesoppgaver.md"

echo "Generating markdown file from files in $SOURCE_DIR"

echo "# Oppgavesett: AWS - Console, VPC og EC2" > "$TARGET_FILE"

echo "# Innholdsfortegnelse

# Innholdsfortegnelse 

1. [Oppsett av infrastruktur](#oppgave-1-sett-opp-infrastruktur)
2. [Sett opp database](#oppgave-2-sett-opp-database)
3. [Sett opp backend-applikasjon med Docker](#oppgave-3-sett-opp-backend-applikasjon-med-docker)
4. [Implementer logging og overvåkning](#oppgave-4-implementer-logging-og-overvåkning)
5. [Custom CloudWatch Metrics](#oppgave-5-custom-cloudwatch-metrics)
6. [Implementering av AWS Lambda for periodiske oppgaver](#oppgave-6-ekstra-oppgave-for-de-som-vil-teste-er-i-utgangspunktet-neste-ukes-pensum-implementering-av-aws-lambda-for-periodiske-oppgaver)
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

echo "# Sletting av ressurser i etterkant:

Resource Explorer klarer ikke alltid å finne RDS databaser, så disse må slettes manuelt. Dette gjøres ved å gå til RDS i konsollen, velge databasen og slette den.
" >> "$TARGET_FILE"