<?php
/*
	Klasse som vil lese inn Excel-filer med sjekklister og lagre innholdet som et array formatert for tilsynsappen
*/

/** PHPExcel_IOFactory */
require_once 'classes/PHPExcel/IOFactory.php';
date_default_timezone_set('Europe/Oslo');


class Sjekklister {
	// Denne klassen går gjennom alle Excel-filer i mappen gitt med $sjekklister_path og legger disse inn i et array ($data)
	var $sjekklister;
	private $inputFiles;

	function __construct($sjekklister_path='') {
		if (!$sjekklister_path) $sjekklister_path = __DIR__ . DIRECTORY_SEPARATOR . "sjekklister";
		$this->sjekklister = array();
		$this->inputFiles = array();
		$filer = scandir($sjekklister_path);
		foreach ($filer as $inputFileName) {
			// Ignorerer filer som ikke ender på '.xlsx'
			if ( strpos($inputFileName, '.xlsx') !== false ) {
				$this->inputFiles[] = $sjekklister_path.'/'.$inputFileName;
			}
		}
		unset($filer);
	}
	
	function loadData($malform='nb_NO') {
		// Laster inn Excel-filene i sjekklister-mappen
		// Resultat: $this->sjekklister blir et array over fagområder, underområder og sjekklister
		foreach ($this->inputFiles as $inputFileName) {
			// Laster inn Excel-dokumentet
			$inputFileType = PHPExcel_IOFactory::identify($inputFileName);
			$objReader = PHPExcel_IOFactory::createReader($inputFileType);
			$objPHPExcel = $objReader->load($inputFileName);
			//$objPHPExcel = PHPExcel_IOFactory::load($inputFileName);
			$loadedSheetNames = $objPHPExcel->getSheetNames();
			// Går gjennom arkene i dokumentet
			foreach($loadedSheetNames as $sheetIndex => $loadedSheetName) {
				// Sjekker om navnet på arket er gyldig (dvs "01 fagområde" el tilsvarende)
				if ( $this->checkValidSheetName($loadedSheetName) ) {
					$objPHPExcel->setActiveSheetIndexByName($loadedSheetName);
					$sheetData = $this->crunchSheet($loadedSheetName, $objPHPExcel->getActiveSheet()->toArray(null,true,true,true), $malform);
					$this->sjekklister = array_merge($this->sjekklister, $sheetData);
				}
			}
			unset($loadedSheetNames);
			unset($objPHPExcel, $objReader);
		}
	} // End function loadData

	// Behandler nåværende Excel-ark
	private function crunchSheet($sheetName, $data, $malform='nb_NO') {
		$hovedindex = substr($sheetName, 0, 2);
		$result_mal = array(
			'Malform'=>$malform,
			'Navn'=>'',
			'Sjekklister' => array()
		);
		$o_mal = array(
			'Navn' => '',
			'Undertittel' => array(),
		);
		$l_mal = array(
			'Navn' => ''
		);
		$spm_mal = array(
			'TemaRef' => array(),
			'Sporsmal' => '',
			'Sjekkpunkt' => array(),
			'Hjemmel' => array()
		);
		$sheetData = array($hovedindex => $result_mal);
		unset($result_mal);
		// Prosesserer rad for rad
		$lastkey = '';
		// Underområde-rekkefølge
		$o_index = 0;
		// Sjekkliste-rekkefølge
		$l_index = 0;
		// Spørsmål-rekkefølge
		$spm_index = 0;
		// Sjekkpunkt-rekkefølge
		$sp_index = 0;
		// Første rad er headere
		$skip_row = true;
	
		foreach ($data as $row) {
			// Forutsetter at cellene er organisert som følger:
			// A = nøkkel, B = nb_NO, C = nn_NO, D = hjemmel, E = TemaRef, F = Kommentarer
			// setter hvilket felt som skal brukes som språk
			$hjemmel = 'D';
			$temaref = 'E';
		
			if ($malform == 'nb_NO') {
				$l = 'B';
				$l2 = 'C';
			} else {
				$l = 'C';
				$l2 = 'B';
			}
			// Hopper over første linje
			if ($skip_row === true) {
				$lastkey = 'header';
				$skip_row = false;
				continue;
			}
			$thiskey = trim(strtolower($row['A']));
			$keyinfo = $this->translateKey($thiskey);

			// Finner ut indeksnumre
			if ( $keyinfo['o_index'] != $o_index && $keyinfo['o_index'] > 0 ) {
				// Endring i $o_index
				$o_index = $keyinfo['o_index'];
				$sheetData[$hovedindex]['Sjekklister'][$o_index] = $o_mal;
				// Dette betyr at l_index, spm_index og sp_index skal nullstilles
				$l_index = 0;
				$spm_index = 0;
				$sp_index = 0;
			}
			if ( $keyinfo['l_index'] != $l_index && $keyinfo['l_index'] > 0 ) {
				// Endring i $l_index
				$l_index = $keyinfo['l_index'];
				$sheetData[$hovedindex]['Sjekklister'][$o_index][$l_index] = $l_mal;
				// Dette betyr at spm_index og sp_index skal nullstilles
				$spm_index = 0;
				$sp_index = 0;
			}
			if ( $keyinfo['spm_index'] != $spm_index && $keyinfo['spm_index'] > 0 ) {
				// Endring i $l_index
				$spm_index = $keyinfo['spm_index'];
				$sheetData[$hovedindex]['Sjekklister'][$o_index][$l_index][$spm_index] = $spm_mal;
				// Dette betyr at sp_index skal nullstilles
				$sp_index = 0;
			}
			//var_dump($keyinfo);
			if ( $thiskey == 'navn' ) {
				// Dette er fagområdets navn
				$sheetData[$hovedindex]['Navn'] = $this->getLang($row, $l, $l2);

			} elseif ( $keyinfo['type'] == 'Områdenavn' ) {
				// Det dreier seg om et underområde-navn
				$sheetData[$hovedindex]['Sjekklister'][$o_index]['Navn'] = $this->getLang($row, $l, $l2);

			} elseif ( $keyinfo['type'] == 'Undertittel' ) {
				// Undertittel til underområde
				$undertittel = $this->getLang($row, $l, $l2);
				$sheetData[$hovedindex]['Sjekklister'][$o_index]['Undertittel'][] = $undertittel;
		
			} elseif ( $keyinfo['type'] == 'Listenavn' ) {
				// Navn på liste
				$sheetData[$hovedindex]['Sjekklister'][$o_index][$l_index]['Navn'] = $this->getLang($row, $l, $l2);

			} elseif ( $keyinfo['type'] == 'Spm' ) {
				// Dette er et spørsmål
				$sheetData[$hovedindex]['Sjekklister'][$o_index][$l_index][$spm_index]['Sporsmal'] = $this->getLang($row, $l, $l2);
				if ($row[$temaref] != '') {
					// Setter temaref
					$temarefs = explode(';', $row[$temaref]);
					foreach ($temarefs as $ref) {
						$sheetData[$hovedindex]['Sjekklister'][$o_index][$l_index][$spm_index]['TemaRef'][] = trim($ref);
					}
				}
				if ($row[$hjemmel] != '') {
					// Setter hjemler
					$hjemler = explode(';', $row[$hjemmel]);
					foreach ($hjemler as $denne) {
						$sheetData[$hovedindex]['Sjekklister'][$o_index][$l_index][$spm_index]['Hjemmel'][] = $denne;
					}
				}
		
			} elseif ($keyinfo['type'] == 'Sjekkpunkt') {
				// Dette er enten et sjekkpunkt eller et mellomrom
				if ($o_index > 0 && $l_index > 0 && $spm_index > 0) {
					// Dette burde være et sjekkpunkt til et spørsmål
					if ( $this->getLang($row, $l, $l2) != '') { 
						// Det er ikke en tom linje, behandle den som et sjekkpunkt
						$sp_index++;
						$sheetData[$hovedindex]['Sjekklister'][$o_index][$l_index][$spm_index]['Sjekkpunkt'][$sp_index] = $this->getLang($row, $l, $l2);
					}
				}

			} elseif ( $keyinfo['type'] == 'Tema' ) {
				// Det dreier seg om et Tema
				$t_index = $keyinfo['t_index'];
				$sheetData[$hovedindex]['Tema'][$t_index] = $this->getLang($row, $l, $l2);
			}
		}
		return $sheetData;
	}

	// Sjekker arknavnet og ser om det inneholder en indeks
	private function checkValidSheetName($sheetName) {
		$index = substr($sheetName, 0, 2);
		if (is_numeric($index)) 
			return $index;
		else
			return false;
	}

	private function getLang(&$row, &$l, &$l2) {
		// Verdien kan aldri være NULL (appen krasjer i iOS 7.1), så vi setter den til tom string hvis den er tom
		if ($row[$l] == '' && $row[$l2] != '') {
			$retval = $row[$l2] != NULL ? $row[$l2] : "";
		} else {
			$retval = $row[$l] != NULL ? $row[$l] : "";
		}
		return $retval;
	}

	// Tolker navnet til nøkkelen
	// Svarer med et array som gir indekser og type innhold (spm, listenavn, o.l.)
	private function translateKey($thiskey) {
		$result = array(
			'type' => '',
			'o_index' => 0,
			'l_index' => 0,
			'spm_index' => 0,
			't_index' => 0,
		);
		$keyparts = explode(' ', $thiskey);
		//var_dump($keyparts);
		// Henter ut første og siste verdi fra keyparts
		reset($keyparts);
		$code = current($keyparts);
		end($keyparts);
		$last = current($keyparts);
		reset($keyparts);
	
		if ( $code == 'tema' ) {
			// Dette er en temalinje
			$result['type'] = 'Tema';
			$result['t_index'] = intval($last);
		} else {
			// Ikke et tema, sjekker andre typer
			if ( strpos($code, 'o') === 0 && is_numeric( substr($code, 1, 1) ) ) {
				// Setter område-indeks
				$result['o_index'] = intval(substr($code, 1, 1));
			}
			// Unntak i tilfelle det står 'område 1 navn el.l.'
			if ( strpos($code, 'omr') === 0 ) {
				$result['o_index'] = intval($keyparts[1]);
			}
			if ( strpos($code, 'l') !== false && is_numeric( substr($code, strpos($code, 'l')+1, 1) ) ) {
				// Setter liste-indeks
				$result['l_index'] = intval(substr($code, strpos($code, 'l')+1, 1));
			}
			// Setter type nøkkel
			if ( strpos( $thiskey, 'undertittel' ) !== false ) {
				// Undertittel for et område
				$result['type'] = 'Undertittel';
			} elseif ( strpos($thiskey, 'sjekkpunkt') !== false || ( $thiskey == '' ) ) {
				// Dette er et sjekkpunkt eller en blank linje. Setter ikke indeks, det tas utenfor funksjonen
				$result['type'] = "Sjekkpunkt";
			} elseif ( strpos($thiskey, 'spm') !== false ) {
				$result['type'] = 'Spm';
				// Setter spm-indeks fra siste del av $keyparts
				end($keyparts);
				$result['spm_index'] = intval(current($keyparts));
				reset($keyparts);
			} elseif ( $last == 'navn' && $result['l_index'] > 0 ) {
				// Dette er navnet på en listen
				$result['type'] = 'Listenavn';
			} elseif ( $last == 'navn' && $result['o_index'] > 0 ) {
				// Navn på underområde
				$result['type'] = 'Områdenavn';
			}
		}
		return $result;
	}
} // End Class
/*
$test = new Sjekklister;
$test->loadData();
$keys = count(array_keys($test->sjekklister));
//var_dump($keys);
echo "Antall sjekklister: $keys\n";
*/
?>
