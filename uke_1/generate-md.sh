#!/bin/bash

CURRENT_DIR="$(dirname "$0")"
SOURCE_DIR="$CURRENT_DIR/md/veiledet-oppgave" 
TARGET_FILE="ukesoppgaver.md"

echo "Generating markdown file from files in $SOURCE_DIR"

echo "# Oppgavesett: Docker og docker-compose" > "$TARGET_FILE"

echo "# Innholdsfortegnelse 

1. [Opprette en enkel Docker-kontainer](#oppgave-1-opprette-en-enkel-docker-kontainer)
2. [Bygge og kjøre Docker-kontaineren](#oppgave-2-bygge-og-kjøre-docker-kontaineren)
3. [Bruke Docker Compose](#oppgave-3-bruke-docker-compose)
4. [Kjør applikasjonen med Docker Compose](#oppgave-4-kjør-applikasjonen-med-docker-compose)
5. [Legge til en database](#oppgave-5-legge-til-en-database)
6. [Koble applikasjonen til databasen](#oppgave-6-koble-applikasjonen-til-databasen)
7. [Miljøvariabler](#oppgave-7-miljøvariabler)
8. [Volumer](#oppgave-8-volumer)
9. [Skalerbarhet](#oppgave-9-skalerbarhet)
10. [Helsekontroll](#oppgave-10-helsekontroll)
11. [Feilsøking](#oppgave-11-feilsøking)

" >> "$TARGET_FILE"


for md_file in $(ls "$SOURCE_DIR"/*.md | sort); do
    sed 's/^[[:space:]]*>/>/' "$md_file" >> "$TARGET_FILE"
    echo "\n\n" >> "$TARGET_FILE"
done
