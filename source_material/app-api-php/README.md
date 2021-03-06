# Example Web API running in PHP #

This is a fully functional PHP application that will serve the DiBK Tilsyn app with it's JSON formatted sources for municipial data, translations and check lists.

## Requirements ##

* Web server (Apache, nginx, anything able to run PHP code)
* PHP 7 (will probably also run in 5.6) with at least the modules **zip**, **mcrypt** and **apcu** installed
* [PHP Composer](https://getcomposer.org)

To simplify, we can recommend [running this application in Docker](../app-api-php_with_docker/), using a customised version of an apache-php7 image.

PS! Running in Windows will require some rewrite of the code, as paths are delimited by "\" and not "/".

## Install ##

To install the necessary libraries, run composer update inside the root path of this folder, e.g.:

`composer update`

After that, the server should be able to run.

In order to use RESTful URLs, please use the provided _htaccess file (rename it to .htaccess) with Apache. Otherwise, please take a look at the [Slim Framework doumentation](https://www.slimframework.com/docs/start/web-servers.html) for more options.

## How it works ##

The web application reads the Excel files inside Library/ and Library/sjekklister to deliver JSON formatted responses to  API calls. For municipalities, it reads all data from Library/kommuner-alle.json and delivers it with some small changes (timestamp and path to coat of arms).

You may construct new checklists by adding new Excel files to Library/sjekklister. When properly formatted, they will add new checklists to the app.

The application uses an older version of the [Slim Framework](https://www.slimframework.com) to do the RESTful stuff, and uses the [PHPExcel class](https://github.com/PHPOffice/PHPExcel) to read from Excel files.

# License for use #

The application is licensed under the Apache License, Version 2.0. This license includes all files, except those distributed with their own licenses.

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
