<!DOCTYPE html> 
<html>
<head>
<?php 
	$footer = '
    <div data-role="footer">
		<h4>Direktoratet for byggkvalitet</h4>
	</div>';
?>
<meta charset="UTF-8">
<title>jQuery Mobile Web App</title>
<link rel="stylesheet" type="text/css" href="../css/dibk-api.min.css">
<link rel="stylesheet" type="text/css" href="../css/jquery.mobile.icons.min.css">
  <link rel="stylesheet" href="//code.jquery.com/mobile/1.4.2/jquery.mobile.structure-1.4.2.min.css" /> <link rel="stylesheet" type="text/css" href="../css/style.css">
  <script src="//code.jquery.com/jquery-1.10.2.min.js"></script> 
  <script src="//code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.js"></script> 
</head> 
<body > 

<div data-role="page" id="page">
	<div data-role="header">
		<h1>API for tilsynsappen</h1>
	</div>
	<div data-role="content">	
   		<div>
        <p>Dette er en beskrivelse av metoder og dataformater for REST-APIet som brukes av DiBK Kommunale Tilsyn. Metodene er kun tilgjengelige med DIGEST-autentisering. Variabler i URLen er merket <span class="variabel">:slik</span>. Klikk på ønsket metode for mer informasjon.</p>
        </div>
		<ul data-role="listview">
			<li><a href="#page2">Kommuner</a></li>
            <li><a href="#page3">Tilsyn</a></li>
			<li><a href="#page4">Sjekklister</a></li>
		</ul>		
	</div>
	<?= $footer ?>
</div>

<div data-role="page" id="page2">
	<div data-role="header">
    <a class="ui-btn-left ui-btn-corner-all ui-btn ui-icon-home ui-btn-icon-notext ui-shadow" title=" Home " data-form="ui-icon" data-role="button" role="button" href="#page"> Tilbake </a>
		<h1>Kommuner</h1>
	</div>
	<div data-role="content">	
		<code>/kommuner/v1/<span class="variabel">:knr</span></code>
	  <p>Samling for operasjoner som omhandler kommuneinformasjon.</p>
	  <h3>GET</h3>
		<p><span class="variabel">:knr</span> = &quot;alle&quot;: Hent inn array over alle kommuner i Norge, der hver kommune er et objekt. Merk at &quot; kommune&quot; er utelatt fra navnet, slik at man kan bruke navnet i kortere form hvis nødvendig.</p>
		<p><span class="variabel">:knr</span> = [kommunenr, f.eks. &quot;1902&quot;] vil returnere info om én kommune. Dette inkluderer også URL til kommunevåpenet i PDF-format.</p>
	</div>
	<?= $footer ?>
</div>

<div data-role="page" id="page3" class="ui-grid-solo">
	<div data-role="header">
    <a class="ui-btn-left ui-btn-corner-all ui-btn ui-icon-home ui-btn-icon-notext ui-shadow" title=" Home " data-form="ui-icon" data-role="button" role="button" href="#page"> Tilbake </a>
		<h1>Tilsyn</h1>
	</div>
	<div data-role="content">	
		<p><code>/tilsyn/v1/<span class="variabel">:inn</span></code></p>
		<p>Metode for å hente inn oversettelser og sjekklister til appen, samt utfaset POST-metode for å sende inn tilsynsdata.</p>
		<h3>GET</h3>
		<p><span class="variabel">:inn</span> = "rev" - Henter revisjonsnummer og -dato for oppsettet
	  </p>
		<p><span class="variabel">:inn</span> = "hent_[målform]" - Henter inn oppsettsdata, maloppsett og språkdefinisjoner. Tilgjengelige målformer er 
	  </p>
	  <ul>
    <li>"nb_NO" - norsk bokmål</li>
    <li>"nn_NO" - norsk nynorsk</li>
    <li>Dersom ikke spesifisert brukes "nb_NO"</li>
    </ul>

    <h3>POST</h3>
    <p><span class="variabel">:inn</span> = [kommunenr] - Brukes for å sende inn tilsynsdata til statistikkbasen.
      Krever parameteret tilsynsdata, som er en JSON-representasjon av tilsynsdata relevant for statistikk.		
    Data lagres ikke lenger i databasen, APIet kvitterer bare for mottaket.</p>
	</div>
	<?= $footer ?>
</div>

<div data-role="page" id="page4">
	<div data-role="header">
    <a class="ui-btn-left ui-btn-corner-all ui-btn ui-icon-home ui-btn-icon-notext ui-shadow" title=" Home " data-form="ui-icon" data-role="button" role="button" href="#page"> Tilbake </a>
		<h1>Sjekklister</h1>
	</div>
	<div data-role="content">
	  <p><code>/sjekklister/v1/<span class="variabel">:malform</span></code></p>
	  <p>Denne  metoden returnerer DiBKs sjekklister for kommunale tilsyn, som grunnlag for eventuelle andre tilsynsapplikasjoner.</p>
	  <p>Dette er et enkelt REST-kall over GET-metoden. Spesifiser ønsket målform med parameteret :malform. Tilgjengelige verdier er &quot;nb_NO&quot; for bokmål og &quot;nn_NO&quot; for nynorsk.</p>
	  <p>Returverdien er et assosiativt array med en oppbygning som inneholder fagområder, underområder, sjekklister, spørsmål. Det tar vare på rekkefølger og hjelpetekster.</p>
	</div>
	<?= $footer ?>
</div>

</body>
</html>
