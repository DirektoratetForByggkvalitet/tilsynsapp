# Kildekode for tilsynsapp for Kommunale tilsyn #

Dette biblioteket inneholder all kildekode for DiBK sin iPad-app for kommunale tilsyn. Kildekoden er fritt tilgjengelig som et Xcode-prosjekt, og krever dermed Apples Xcode for å kunne bygge appen. Dersom du vil bygge din egen versjon av appen står du fritt til å gjøre det.

Koden inneholder et brukernavn og passord som fungerer for å hente ut sjekklister og oversettelser fra https://app-api.dibk.no via REST-kall. Dette kan fritt benyttes av andre for samme formål:

Brukernavn: tilsynsapp
Passord: b07ac2d67a81bd4d2fc45fbb5beac45ab8a42433

## Noen problemområder som eksisterer i koden ##

Per iOS versjon 10.2 ser det ikke ut til at versjon 1.2.0 av appen fungerer. Den krasjer med en feilmelding. Dersom noen finner ut av dette og kan tilby en patch er vi veldig takknemlige.

Appen benytter et rammeverk for å snakke med DropBox som kan være ikke-fungerende per i dag.
### Hvem kan jeg snakke med? ###

Kildekoden eies av Direktoratet for byggkvalitet. Vi tilbyr dessverre ingen brukerstøtte på innholdet i koden.