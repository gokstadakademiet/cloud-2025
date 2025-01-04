# AWS Free Tier

I ukesoppgavene i dette kurset vil vi kun benytte tjenester som faller innenfor rammene av [AWS Free Tier](https://aws.amazon.com/free/). Dersom du bruker tjenester utenfor de som er spesifisert i ukesoppgavene, eller unnlater å slette ressurser i AWS etter eksperimentering, kan dette medføre kostnader for deg.

> [!CAUTION]
> **Enhver kostnad som påløper er brukerens eget ansvar. Gokstad Akademiet fraskriver seg ethvert ansvar for kostnader som kan oppstå som følge av bruk eller eksperimentering med AWS-tjenester. Vær derfor meget varsom når du eksperimenterer med nye tjenester, og vær sikker på at de er innenfor free tier, eller til en pris du er villig til å betale.**

Nedenfor finner du tiltak som kan hjelpe med å unngå bruk av tjenester utenfor AWS Free Tier. Det anbefales at alle setter opp både `Zero Spend Budget` og `AWS Free Tier-varsler`. For de som er interesserte, kan du lese mer om free tier [her](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/tracking-free-tier-usage.html).

## Zero Spend Budget - Oppsett for å avdekke eventuelle tjenester som har en kostnad

1. Logg inn på AWS Management Console.
2. Gå til "Billing and Cost Management" dashboardet.
3. Velg "Budgets" fra menyen på venstre side.
4. Klikk på "Create budget".
5. Velg "Use a template", velg "Zero spend budget"
6. Gi budsjettet et navn, for eksempel "Zero Spend Budget".
8. Konfigurer varsler slik at du mottar en e-post hvis kostnadene overstiger 0 NOK. Sett gjerne denne til den eposten du sjekker oftest. 
9. Klikk "Create" for å opprette budsjettet.

## AWS Free Tier-varsler

1. Logg inn på AWS Management Console og åpne Billing-konsollen på https://console.aws.amazon.com/billing/.
2. Under "Preferences" i navigasjonsruten, velg "Billing preferences".
3. For "Alert preferences", velg "Edit".
4. Velg "Receive AWS Free Tier alerts" for å melde deg på Free Tier-varsler. 
5. Velg "Update".

## Bruk AWS Resource Explorer

AWS Resource Explorer er et verktøy som lar deg søke etter og finne AWS-ressurser i kontoen din. Dette kan være spesielt nyttig for å avdekke ressurser som du kanskje har glemt å slette etter en workshop eller eksperimentering.

### Hvordan bruke AWS Resource Explorer

1. Logg inn på AWS Management Console.
2. Gå til "Resource Explorer" fra tjenestemenyen.
3. Bruk søkefeltet til å søke etter spesifikke ressurser, for eksempel EC2-instanser, S3-bøtter, eller RDS-databaser.
4. Filtrer resultatene etter region, ressurs-type, eller andre kriterier for å få en bedre oversikt.
5. Gå gjennom listen over ressurser og identifiser de som ikke lenger er nødvendige.
6. Slett eller stopp ressurser som ikke er i bruk for å unngå unødvendige kostnader.

Ved å regelmessig bruke AWS Resource Explorer kan du bli mer sikker på at du ikke har ubrukte ressurser som påløper kostnader, og dermed holde deg innenfor AWS Free Tier-grensene.