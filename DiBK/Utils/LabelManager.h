//
//  Lang.h
//  DiBK
//
//  Created by david stummer on 03/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kLanguageBokmal = 0,
    kLanguageNynorsk
}
Language;

@interface LabelManager : NSObject

+ (NSString*)getTextForParent:(NSString*)parentKey Key:(NSString *)key;
+ (Language)getCurrentLanguage;
+ (void)switchLanguage;
+ (NSString*)getCurrentLanguageName;

@end

/*
general:
 close: Ferdig
 yes: Ja
 no: Nei
 maybe: Delvis
 edit: Rediger
 close: Ferdig
 error: Error
 ok: OK
 
start_screen
 text_1: Før du starter...
 text_2: Ditt navn
 text_3: Din kommune
 text_4: Velg målform
 text_5: Jeg godkjenner at kopier av ferdig utfylte tilsynsrapporter vil sendes til DiBK.
 
dashboard_screen
 text_1: Tilsyn
 text_2: Etter tilsyn gjennomført iht. pbl § 25-1
 text_3: Nytt tilsyn
 text_4: Pågående tilsyn
 text_5: Dokumentarkiv

archive_screen
 text_1: Her finner du dine siste dokumenter
 text_2: Tilsynsrapporter
 text_3: Regelverk
 
settings_dialog
 text_1: Innstillinger
 text_2: Filoverføring
 text_3: Clear Cache
 text_4: Switch Color Scheme
 
file_transfer_screen
 text_1: Redigering av dokumentarkiv
 text_2: Du kan nå åpne følgende nettside i en nettleser:
 text_3: For å autorisere deg må du oppgi følgende kode:
 text_4: Nettsiden vil la deg gjøre endringer i dokumentarkivet, laste ned  og opp filer, slette filer. samt opprette og fjerne mapper.
 text_5: NB! Du må ikke slå av nettbrettet eller gå bort fra dette vinduet mens du bruker nettsiden.
 text_6: Avslutt redigeringen
 
report_home_screen
 text_1: Nytt tilsyn
 text_2: Velg ønsket kapittel for utfylling
 text_3: Informasjon
 text_4: Informasjon om tiltaket, foretak, deltagere og andre faktiske forhold
 text_5: Valg av fagområder/sjekklister
 text_6: Velg hva tilsynet skal omfatte av fagområder, sjekklister og eventuelt egne spørsmål
 text_7: Gjennomføring
 text_8: Utfylling av sjekklister med kommentarer, bilder og annen dokumentasjon av funn
 text_9: Konklusjon
 text_10: Sjekk informasjon, skriv oppsummering, avslutt og send rapport
 text_11: Ferdigstilling
 text_12: Bekreft og ferdigstill tilsynsrapporten
 
chapter_one_screen
 text_1: 1 Informasjon
 text_2: Kommune
 text_3: Tilsynsfører
 text_4: Kommunens saksnr.:
 text_5: Rapporten gjelder:
 text_6: Dato Foretatt :
 text_7: Adresse/sted
 text_8: Gnr:
 text_9: Bnr:
 text_10: Fnr:
 text_11: Snr:
 text_12: Kommentar
 text_13: Bakgrunn for tilsynet
 text_14: Etablert rutine byggesakskontoret
 text_15: Særskilt brannobjekt
 text_16: Publikumsbygg
 text_17: Bekymringsmelding
 text_18: Uønsket hendelse
 text_19: Seksjonering
 text_20: Ferdigattest er omsøkt
 text_21: Annet:
 text_22: Deltagere
 text_23: Legg til flere
 text_24: Status i byggesaken
 text_25: Tiltaket er søknadspliktig
 text_26: Rammetillatelse er omsøkt
 text_27: Rammetillatelse er gitt
 text_28: Igangsettingsstillatelse er omsøkt
 text_29: Igangsettingsstillatelse er gitt
 text_30: Midl. brukstillatelse er omsøkt
 text_31: Midl. brukstillatelse er gitt
 text_32: og tilbaketrukket
 text_33: Ferdigattest er omsøkt
 text_34: Ferdigattest er gitt
 text_35: og tilbaketrukket
 text_36: Titaket er
 text_37: uten nødvendig tillatelse
 text_38: Andre Kommentarer
 
chapter_one_manager_screen
 text_1: Navn
 text_2: Org.nr.
 text_3: Firmanavn
 
chapter_two_screen
 text_1: 2 Valg av fagoråder og sjekklister
 text_2: Fagområder
 text_3: Velg fagområdet - deretter sjekklister
 text_4: Velg ønsket sjekkliste
 text_5: Utvalgte sjekklister
 
chapter_three_screen
 text_1: 3 Utfylling
 text_2: Kommentarer
 text_3: Legg til foto
 
chapter_three_question_dialog
 text_1: Fjern spørsmål fra tilsyn
 text_2: Slett spørsmål
 text_3: Legg til nytt spørsmål
 text_4: Plasser nytt spm før nåværende spm
 text_5: Plasser nytt spm etter nåværende spm
 
chapter_three_comment_dialog
 text_1: Rediger
 
chapter_three_photo_dialog
 text_1: Skriv kommentar her
 
chapter_four_screen
 text_1: 4 Konklusjon
 text_2: Svar på utfylling
 text_3: Vurdering
 text_4: Oppfølgning etter tilsynet
 text_5: Kan tilsynet avsluttes?
 
chapter_five_screen
 text_1: 5 Ferdigstilling
 text_2: Kontroller feltene nedenfor
 text_3: Kommune
 text_4: Kommunens saksnr.:
 text_5: Tilsynsfører
 text_6: Dato
 text_7: Bekreft og ferdigstill tilsynsrapporten
 text_8: E-postadresse
 text_9: (En kopi av tilsynet blir sendt til denne adressen)
 text_10: Jeg godkjenner at kopier av ferdig utfylte tilsynsrapporter vil sendes til DiBK.
 text_11: Ferdigstill
 text_12: Error
 text_13: Please enter Kommune Saksnr and Rapport name
 text_14: Could not push report to server! Please try again with an internet connection.
 
web_service_manager:
 text_1: Could not find cached data. Please find an internet connection and try again.
*/