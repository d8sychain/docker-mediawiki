## Add Wikibase (Repository and/or Client)
### reference: https://www.mediawiki.org/wiki/Wikibase/Installation
### Do not use the ExtensionManager for this extension unless you remove the lines that it adds to the end of LocalSettings.php

* Add extension Wikibase
* Add the following lines to LocalSettings_Extensions.php
	* **Enable Wikibase Repository only**
	```
	## Wikibase Repository only https://www.mediawiki.org/wiki/Extension:Wikibase_Repository
		$wgEnableWikibaseRepo = true;
		$wgEnableWikibaseClient = false;
		require_once "$IP/extensions/Wikibase/repo/Wikibase.php";
		require_once "$IP/extensions/Wikibase/repo/ExampleSettings.php";
	```
	* **Enable Wikibase Client only**
	```
	## Wikibase Client only https://www.mediawiki.org/wiki/Extension:Wikibase_Client
		$wgEnableWikibaseRepo = false;
		$wgEnableWikibaseClient = true;
		require_once "$IP/extensions/Wikibase/client/WikibaseClient.php";
		require_once "$IP/extensions/Wikibase/client/ExampleSettings.php";
	```
	* **Enable Wikibase Repository and Wikibase Client**
	```
	## Wikibase https://www.mediawiki.org/wiki/Wikibase
		$wgEnableWikibaseRepo = true;
		$wgEnableWikibaseClient = true;
		require_once "$IP/extensions/Wikibase/repo/Wikibase.php";
		require_once "$IP/extensions/Wikibase/repo/ExampleSettings.php";
		require_once "$IP/extensions/Wikibase/client/WikibaseClient.php";
		require_once "$IP/extensions/Wikibase/client/ExampleSettings.php";
	```
* Create the file `composer.local.json` if it does not already exist and use the reference below *(be sure to remove the example lines)*
	* Include the following into composer.local.json at the root of your mediawiki installation:
		* `"extensions/Wikibase/composer.json"`
			* Note the comma `,` after each previous line
			* See the following as a reference *(ues this whole code block if you did not already have a file `composer.local.json` )*:
		```
		{
		  "extra": {
			"merge-plugin": {
			  "include": [
				"example_1.json",
				"example_2.json",
				"extensions/Wikibase/composer.json"
			  ]
			}
		  }
		}
		```
* Bash into the docker container
	* `docker exec -it name_of_docker_container /bin/bash`
* Run some commands from the root of your mediawiki installation:
	* `cd /config/www/mediawiki`
	* `composer install --no-dev`
	* `php maintenance/update.php`
	* `php extensions/Wikibase/lib/maintenance/populateSitesTable.php`
	* Wikibase Repository only
		* `php extensions/Wikibase/repo/maintenance/rebuildItemsPerSite.php`
	* For Wikibase Client only
		* `php extensions/Wikibase/client/maintenance/populateInterwiki.php`
	* Wikibase Repository and Wikibase Client
		* `php extensions/Wikibase/epo/maintenance/rebuildItemsPerSite.php`
		* `php extensions/Wikibase/client/maintenance/populateInterwiki.php`
* Done - Verify your installation