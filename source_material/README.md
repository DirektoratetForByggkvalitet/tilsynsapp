# Source Material #

This directory contains all the files necessary to make a separate API to serve DiBK Tilsyn

* files - contains coat of arms for the municipalities
* sjekklister - contains the check lists in their original Excel format
* json - contains the .json files the app actually expects in order to setup all strings and checklists. sjekklister_*.json are actually included in translations_and_checklists-*.json
* Oversettelser.xlsx - The original source for all UI strings in the app
* app-api-php - A fully functional API server built in PHP to provide DiBK Tilsyn with its checklists and translations
* app-api-php_with_docker - Some help using Docker to run the app-api server