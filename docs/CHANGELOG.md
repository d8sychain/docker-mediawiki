CHANGELOG

# Docker MediaWiki


## 2019-10-21 1.33-3

* *Changes to 1.33-3 from 1.33-2 may cause issues if updating the docker image*
	If you have completed the installer already and started using MediaWiki
	* Delete the following files: **/config/www/mediawiki/ExtraLocalSettings.php** and **/config/nginx/nginx.conf**
	* Remove line 163 **# Load extra settings** and line 164 **require ExtraLocalSettings.php';** from **LocalSettings.php**
	* Restart the container.
* Removed extension **ExtensionDistributor** and associated configurations
* Developed and added **ExtensionManager** to simply adding or removing extensions
* Updated upgrade scripts to tie in with **ExtensionManager**
* Split **ExtraLocalSettings.php** into two different files **LocalSettings_Extras.php** and **LocalSettings_Extensions.php**
* Minor changes to **LocalSettings_Extras.php** and **LocalSettings_Extensions.php**
* Fixed **nginx.conf** where if no file was specified in the URI it would return 403 instead of an internal redirect to index.php
* Several edits to container startup scrips
* Update **Upgrade** script to backup SQLite database if using the default database directory
* Updated README to reflect changes to use
* Added additional information to README
* Corrected several README typos
* Updated GOALS


## 2019-10-15 1.33-2

* Added poppler-utils fix for extension PdfHandler
* Fixed typo in cont-init.d script 15-config-wiki


## 2019-10-15 1.33-1

* Initial version
