#!/bin/bash

CURRENT_DIR="$(dirname "$0")"
SOURCE_DIR="$CURRENT_DIR/md/veiledet-oppgave" 
TARGET_FILE="ukesoppgaver.md"

echo "Generating markdown file from files in $SOURCE_DIR"

echo "# Oppgavesett: AWS - Console, VPC og EC2" > "$TARGET_FILE"

echo "# Innholdsfortegnelse

1. [Oppsett av VPC og EC2-instans](#oppgave-1-oppsett-av-vpc-og-ec2-instans)
2. [Installasjon av webserver og database](#oppgave-2-installasjon-av-webserver-og-database)
3. [Implementer backend for oppgavestyring](#oppgave-3-implementer-backend-for-oppgavestyring)
4. [Implementer frontend for oppgavestyring](#oppgave-4-implementer-frontend-for-oppgavestyring)
5. [Migrering til containere med Docker på EC2](#oppgave-5-migrering-til-containere-med-docker-på-ec2)
6. [Konfigurering av Security Groups for Docker](#oppgave-6-konfigurering-av-security-groups-for-docker)
" >> "$TARGET_FILE"

echo "# Introduksjon til skyteknologi med AWS: Oppgavestyringssystem

I dette kurset skal vi bygge et enkelt oppgavestyringssystem ved hjelp av AWS-tjenester. Vi vil starte med grunnleggende oppsett og gradvis bygge ut funksjonaliteten. Kurset vil fokusere på infrastruktur og AWS-tjenester, med minimal vekt på applikasjonskode.

> [!NOTE]
> **Før du begynner er det viktig at du setter deg inn i AWS Free Tier, se artikkel [her](../aws.md).**
" >> "$TARGET_FILE"

for md_file in $(ls "$SOURCE_DIR"/*.md | sort); do
    sed 's/^[[:space:]]*>/>/' "$md_file" >> "$TARGET_FILE"
    echo "\n\n" >> "$TARGET_FILE"
done