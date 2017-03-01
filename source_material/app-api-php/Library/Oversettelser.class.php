<?php
/*
	Klasse som vil lese inn Excel-filer med sjekklister og lagre innholdet som et array formatert for tilsynsappen
*/

/** PHPExcel_IOFactory */
require_once 'classes/PHPExcel/IOFactory.php';
date_default_timezone_set('Europe/Oslo');


class Oversettelser {
	// Denne klassen går gjennom alle ark i oversettelsesfila, og setter opp labels, infotexts og lists
	var $labels;
	var $infotexts;
	var $lists;
	private $inputFileName;
	private $sheetNames = array(
		'Tekster (labels)',
		'Infotekster (info)',
		'Lister (lists)'
	);

	// Constructor - setter variablene
	function __construct() {
		$this->labels = array();
		$this->infotexts = array();
		$this->lists = array();
		$this->inputFileName = __DIR__.'/Oversettelser.xlsx';
	}
	
	function loadData($malform='nb_NO') {
		// Laster inn Excel-dokumentet
		$inputFileType = PHPExcel_IOFactory::identify($this->inputFileName);
		$objReader = PHPExcel_IOFactory::createReader($inputFileType);
		$objPHPExcel = $objReader->load($this->inputFileName);
		$loadedSheetNames = $objPHPExcel->getSheetNames();
		// Går gjennom arkene i dokumentet
		foreach($loadedSheetNames as $sheetIndex => $loadedSheetName) {
			if ( $this->checkValidSheetName($loadedSheetName) ) {
				$objPHPExcel->setActiveSheetIndexByName($loadedSheetName);
				$this->crunchSheet($loadedSheetName, $objPHPExcel->getActiveSheet()->toArray(null,true,true,true), $malform);
			}
		}
		unset($loadedSheetNames);
		unset($objPHPExcel, $objReader);
	} // End function loadData

	// Behandler Excel-arket
	private function crunchSheet($sheetName, $data, $malform='nb_NO') {
		$label_mal = array(
			'parentkey'=>'',
			'key'=>'',
			'oldkey'=>'',
			'langcode'=>$malform,
			'string' => '',
			'comments' => ''
		);
		// {"parentkey":"chapter_one_screen","key":"regarding_list","items":[{"value":"1","text":"Stedlig tilsyn \u2013 varslet"},{"value":"2","text":"Stedlig tilsyn \u2013 uanmeldt"},{"value":"3","text":"Dokumenttilsyn"}],"comments":"List for the regarding (Tilsynet gjelder) field"}
		$list_mal = array(
			'parentkey' => '',
			'key' => '',
			//'langcode' => $malform,
			'items' => array(),
			'comments' => ''
		);
		$info_mal = array(
			'key' => '',
			'langcode' => $malform,
			'title' => '',
			'paragraphs' => '',
			'comments' => ''
			
		);
		// Info-arrayet skal behandle dataene inn i et array av typen
		// array ('key' => 'nøkkelen', 'langcode' => 'målform', 'title' => 'text fra index 1', 'paragraphs' => array( 'text fra index 2', 'text fra index 3' ... ))
	
		$p_mal = array(
			'index' => 0,
			'text' => ''
		);
		$spm_mal = array(
			'TemaRef' => array(),
			'Sporsmal' => '',
			'Sjekkpunkt' => array(),
			'Hjemmel' => array()
		);

		// Prosesserer rad for rad
		$lastkey = '';
		// Avsnitt-indeks. Brukes av infotekster
		$p_index = 0;
		// Holder på infotekst før den postes til $this->infotexts
		$thisinfo = '';
		// Samme for lister
		$thislist = '';


		// Første rad er headere
		$skip_row = true;
		
		// Setter opp formatet avhengig av type data. 
		// Sjekker dette med arkets navn, og setter $datatype
		// labels = 1, info = 2, lists = 3
		$type_text = explode(' ', $sheetName)[1];
		if ( $type_text == '(labels)' ) {
			$datatype = 1;
		} elseif ( $type_text == '(info)' ) {
			$datatype = 2;
		} else {
			$datatype = 3;
		}

		foreach($data as $row) {
			// Hopper over første linje = header
			if ($skip_row === true) {
				$lastkey = 'header';
				$skip_row = false;
				continue;
			}
			
			if ( $datatype == 1 ) {
				// Behandler labels
			
				$langcode = $row['D'];
				if ( $langcode != $malform ) {
					// Tar ikke med linjen dersom det ikke er riktig målform på linjen
					continue;
				} else {
					$tmp = $label_mal;
					$tmp['parentkey'] = $row['A'];
					$tmp['key'] = $row['C'];
					$tmp['oldkey'] = $row['B'];
					$tmp['string'] = $row['E'];
					if ($row['F'] != '') $tmp['comments'] = $row['F'];
					// Legger linjen til i $this->labels
					$this->labels[] = $tmp;
					//var_dump($tmp);
					unset($tmp);
				}
			
			} elseif ( $datatype == 2 ) {
				// Behandler linjer for infotexts
			
				$langcode = $row['B'];
				if ( $langcode != $malform ) {
					// Tar ikke med linjen dersom det ikke er riktig målform på linjen
					continue;
				} else {
					$key = $row['A'];
					if ( $lastkey != $key ) {
						// Ny nøkkel, dette er en tittel
						if ( is_array($thisinfo) ) {
							// Dersom thisinfo eksisterer, post den til infotexts
							$this->infotexts[] = $thisinfo;
						}
						$thisinfo = $info_mal;
						$thisinfo['key'] = $key;
						$thisinfo['title'] = $row['D'] != NULL ? $row['D'] : '';
						$thisinfo['comments'] = $row['E'] != NULL ? $row['E'] : '';
						$lastkey = $key;
					} else {
						// Samme nøkkel, legger til et avsnitt
						if ( is_string($thisinfo['paragraphs']) ) $thisinfo['paragraphs'] = array($thisinfo['paragraphs']);
						if ( !is_array($thisinfo['paragraphs']) ) $thisinfo['paragraphs'] = array();
						$thisinfo['paragraphs'][] = $row['D'] != NULL ? $row['D'] : '';
					}
				}
			} else {
				// Behandler linjer for listetekster
				$parentkey = $row['A'];
				$key = $row['B'];
				$langcode = $row['C'];
				if ( $langcode != $malform ) {
					// Tar ikke med linjen dersom det ikke er riktig målform på linjen
					//echo "Skipper listelinje pga målform \n";
					continue;
				} else {
					if ( $lastkey != $key ) {
						// Ny nøkkel
						// Hvis thislist har innhold, post til $this->lists
						if ( is_array($thislist) ) $this->lists[] = $thislist;

						// Oppretter ny thislist fra malarray
						$thislist = $list_mal;
						$thislist['parentkey'] = $parentkey;
						$thislist['key'] = $key;
						$lastkey = $key;
					}
					// Felles for alle listeobjekter, nye som brukte
					$val = $row['D'] != NULL ? $row['D'] : 0;
					$txt = $row['E'] != NULL ? $row['E'] : '';
					$thislist['items'][] = array(
						'value' => $val,
						'text' => $txt
					);
					if ( $row['F'] != '' ) $thislist['comments'] .= $row['F'].' ';
				}
			} // If $datatype == x
		} // Foreach $data as $row

		if ( is_array($thisinfo) && $datatype == 2 ) {
			// Rydder opp: Hvis thisinfo er satt, post den til infotexts
			$this->infotexts[] = $thisinfo;
		}
		if ( is_array($thislist) && $datatype == 3 ) {
			// Rydder opp: Poster thislist til $this->lists
			$this->lists[] = $thislist;
		}
	}

	// Sjekker arknavnet og ser om det inneholder en indeks
	private function checkValidSheetName($sheetName) {
		if ( in_array($sheetName, $this->sheetNames) ) 
			return true;
		else
			return false;
	}

} // End Class
 /*
// Testkode
$test = new Oversettelser;
$test->loadData();
$ut = $test->lists;
var_dump($ut);
*/

?>
