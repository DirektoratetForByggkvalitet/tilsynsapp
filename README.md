# Kildekode for DiBK Kommunale tilsyn #

Dette repoet inneholder all kildekode for DiBK kommunale tilsyn. Kildekoden ligger her fritt tilgjengelig som et Xcode-prosjekt, og krever dermed Apples Xcode for å kunne bygge appen. Dersom du vil bygge din egen versjon av appen står du fritt til å gjøre det uten vederlag.

Koden inneholder et brukernavn og passord som fungerer for å hente ut sjekklister og oversettelser fra https://app-api.dibk.no via REST-kall og JSON-filer. 
En fungerende versjon av denne API-tjeneren er vedlagt, sammen med kopier av sjekklister og oversettelser i JSON- og Excel-format, i mappen **source_material**.

## Noen problemområder som eksisterer i koden ##

Appen benytter et rammeverk for å snakke med DropBox som kan være ikke-fungerende per i dag. Appen kan også ha problemer med å generere PDF av tilsyn som inneholder mange bilder el.l. som kan bruke opp alt minnet til iPaden.

### Hvem kan jeg snakke med? ###

Direktoratet for byggkvalitet tilbyr dessverre ingen brukerstøtte på innholdet i koden, den er levert "as-is". DiBK har samarbeidet med [Knowit Objectnet AS](https://www.knowit.no/) for å holde appen oppdatert, og de samme har også vært involverte i andre prosjekter som har vært baserte på denne kildekoden. Et tips kan være å kontakte dem for hjelp til å utvikle sin egen versjon av appen.

# Lisens for bruk #

Lisensen gjelder alle kildefiler, med unntak av de biblioteker som har sine egne lisensbetingelser.

Copyright 2017 Direktoratet for byggkvalitet

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.