# Kildekode for DiBK Kommunale tilsyn #

Dette repoet inneholder all kildekode for DiBK kommunale tilsyn. Kildekoden ligger her fritt tilgjengelig som et Xcode-prosjekt, og krever dermed Apples Xcode for å kunne bygge appen. Dersom du vil bygge din egen versjon av appen står du fritt til å gjøre det uten vederlag.

Koden inneholder et brukernavn og passord som fungerer for å hente ut sjekklister og oversettelser fra https://app-api.dibk.no via REST-kall og JSON-filer. Kopier av sjekklister og oversettelser i JSON- og Excel-format ligger sammen med kildekoden, i mappen **source_material**.

## Noen problemområder som eksisterer i koden ##

Per iOS versjon 10.2 ser det ikke ut til at appen fungerer lenger. Den krasjer med en feilmelding. Det er antakelig relativt trivielt å fikse denne feilen, men DiBK har ikke satt av ressurser til å gjøre det.

Appen benytter et rammeverk for å snakke med DropBox som kan være ikke-fungerende per i dag.

### Hvem kan jeg snakke med? ###

Direktoratet for byggkvalitet tilbyr dessverre ingen brukerstøtte på innholdet i koden, den er levert "as-is". DiBK har samarbeidet med [Knowit Objectnet AS](https://www.knowit.no/) for å holde appen oppdatert, og de samme har også vært involverte i andre prosjekter som har vært baserte på denne kildekoden. Et tips kan være å kontakte dem for hjelp til å utvikle sin egen versjon av appen.