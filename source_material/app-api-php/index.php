<?php
require_once 'vendor/autoload.php';
require_once 'Library/HttpDigestAuth.php';

define('CUSTOM_LIBRARY', './Library');

// Mode: production eller development
$_ENV['SLIM_MODE'] = 'production';

$conf = array(
	'api_url' => 'https://your-server-url',
	'apcu_ttl' => 1200,
);
$conf['kommunevapen_url'] = $conf['api_url'].'/files/pdf/###KNR###.pdf';
$conf['malformer'] = array('nb_NO', 'nn_NO');
$conf['users'] = [
	'tilsynsapp' => 'b07ac2d67a81bd4d2fc45fbb5beac45ab8a42433'
];
$conf['realm'] = 'app-api.dibk.no';

// Init av appen
$app = new \Slim\Slim();
$app->add(new \Slim\Extras\Middleware\HttpDigestAuth($conf['users']), $conf['realm']);

// Only invoked if mode is "production"
$app->configureMode('production', function () use ($app) {
	$app->config(array(
		'log.enable' => true,
		'debug' => false
	));
});

// Only invoked if mode is "development"
$app->configureMode('development', function () use ($app) {
	$app->config(array(
		'log.enable' => false,
		'debug' => true
	));
});

$app->setName('app-api');

// START ROUTING
$app->get('/', 'mainPage');

// Lukket API for å hente kommunedata
$app->get('/kommuner/:ver/:knr', 'getKommuner');

// Lukket API for tilsyn
$app->get('/tilsyn/:ver/:inn', 'getTilsyn');
$app->post('/tilsyn/:ver/:inn', 'postTilsyn');

// Åpent API for sjekklister
$app->get('/sjekklister/:ver/:malform', 'getSjekklister');

$app->run();

function getKommuner($ver, $knr) {
	global $conf;
	$app = \Slim\Slim::getInstance();
	
	$apcu_key = 'kommuner-v1.1-'.$knr;
	$data['meta'] = array(
		'success' => false,
		'message' => NULL,
	);
	if (apcu_exists($apcu_key)) {
		$data = apcu_fetch($apcu_key);
	} else {
		$dataTmp = file_get_contents(CUSTOM_LIBRARY . '/kommuner-alle.json');
		$data = json_decode($dataTmp, true);
		$iteration = 0;
		foreach ($data['kommuner'] as $komm) {
			$data['kommuner'][$iteration]['kommunevapen'] = str_ireplace('###KNR###', $komm['knr'], $conf['kommunevapen_url']);
			$iteration++;
		} // foreach
		$data['meta']['timestamp'] = date('c');
		if ( $data['meta']['success'] ) apcu_store($apcu_key, $data, $conf['apcu_ttl']);
	} // apcu_exists($apcu_key)
	toArray($data);
}

function getTilsyn ($ver, $inn) {
	global $conf;
	require_once(CUSTOM_LIBRARY . '/Sjekklister.class.php');
	require_once(CUSTOM_LIBRARY . '/Oversettelser.class.php');
	
	$app = \Slim\Slim::getInstance();
	
	// Filer som brukes til å laste inn tilsynsoppsett
	$data['meta']['timestamp'] = date('c');

	$apcu_key = 'tilsyn-v1.1-'.$inn;

	// Slå av caching ved å legge til '&& 2==1' under
	if (apcu_exists($apcu_key)) {
		$data = apcu_fetch($apcu_key);
	} else {
		//$mysqli = new mysqli($conf['db_host'], $conf['db_user'], $conf['db_password'], $conf['db_name']);
		//if ($mysqli->connect_error) {
		//	$data['meta']['message'] = 'DB Connect Error (' . $mysqli->connect_errno . ') '. $mysqli->connect_error;
		//	return json_encode($data);
		//}
		// Sjekker inn-verdier
		if (substr(strtolower($inn), 0, 4) == 'hent') {
			// Finner ønsket målform
			$malform = substr($inn, 5, strlen($inn));
			// Ingen målform funnet? Da returnerer vi bokmål
			if ( !in_array($malform, $conf['malformer']) ) 
				$malform = 'nb_NO';
			// Leser inn fullt array fra Excel
			// Bruker Sjekklister-klassen til å hente inn sjekklister fra Excel-filene
			$sObj = new Sjekklister;
			$sObj->loadData($malform);
			$data[$malform] = $sObj->sjekklister;
			unset($sObj);

			// Bruker Oversettelser-klassen til å lese inn oversettelser fra Excel
			$oObj = new Oversettelser;
			$oObj->loadData($malform);
			$data['info'] = $oObj->infotexts;
			$data['labels'] = $oObj->labels;
			$data['lists'] = $oObj->lists;
			unset($oObj);
			/*
			// Setter $data['labels']
			$this->setLabels($mysqli);
			// Setter $data['info']
			$this->setInfo($mysqli);
			// Setter $data['lists']
			$this->setLists($mysqli);
			*/
			$data['meta']['success'] = true;
			$data['meta']['message'] = "Translations delivered";
			apcu_store($apcu_key, $data, $conf['apcu_ttl']);
		} else {
			$app->notFound();
		}
		//mysqli_close($mysqli);
	}
	toArray($data);
}
/*
	Mottak for innsendte tilsynsdata. Avvikles med ny versjon, derfor svarer den kun med dummy-svar
*/
function postTilsyn($ver, $inn) {
		global $conf;
		$app = \Slim\Slim::getInstance();
		$data = array('meta'=>array());
		$data['meta']['timestamp'] = date('c');
		/*
		$valid = $this->hasRequiredParameters($this->requiredParams);
		if ($valid instanceof Frapi_Error) {
			return $valid;
		}
		$dbdata = array(
			'knr' => $this->getParam('inn'),
			'innhold_json' => $this->getParam('tilsynsdata'),
			'sender_ip' =>  $_SERVER['REMOTE_ADDR'],
		);
		
		$mysqli = new mysqli($this->c['db_host'], $this->c['db_user'], $this->c['db_password'], $this->c['db_name']);
		if ($mysqli->connect_error) {
			$data['meta']['message'] = 'DB Connect Error (' . $mysqli->connect_errno . ') '. $mysqli->connect_error;
			toArray($data);
		}
		$this->lagre_array($dbdata, $this->c['tilsyn_tabell'], $mysqli);
		mysqli_close($mysqli);
		*/
		$data['meta']['success'] = true;
		$data['meta']['message'] = 'Tilsynsdata blir ikke lenger lagret, vennligst oppdatér appen';
		
		toArray($data);

}

function getSjekklister($ver, $malform) {
	global $conf;
	$app = \Slim\Slim::getInstance();
	require_once(CUSTOM_LIBRARY . DIRECTORY_SEPARATOR . 'Sjekklister.class.php');
	if ($malform != 'nb_NO' && $malform != 'nn_NO') 
		$malform = 'nb_NO';
		
	$app->doAuth = false;
	$apcu_key = 'sjekklister-v1.1-'.$malform;

	if (apcu_exists($apcu_key)) {
		$data = apcu_fetch($apcu_key);
	} else {
		$data = array('meta'=>array());
		$sObj = new Sjekklister;
		$sObj->loadData($malform);
		$data['result'] = $sObj->sjekklister;
		unset($sObj);
		$data['meta']['success'] = true;
		$data['meta']['message'] = "Sjekklister for $malform levert";
		$data['meta']['cache_ts'] = date('c');
		apcu_store($apcu_key, $data, $conf['apcu_ttl']);
	}
	
	toArray($data);
}

function mainPage() {
	$app = \Slim\Slim::getInstance();
	$app->render('mainPage.php');
}

function toArray($data, $format = 'json') {
	global $conf;
	$app = \Slim\Slim::getInstance();
	if ($format == 'json') {
		$app->response->headers->set('Content-Type', 'application/json');
		echo json_encode($data);
	}
}

/**
	Sjekker autentisering mot $conf['users']
**/
function checkAuth() {
	global $conf;
	
}
?>
