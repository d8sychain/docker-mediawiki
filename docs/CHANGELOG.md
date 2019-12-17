CHANGELOG

# Docker MediaWiki

## 2019-12-17 v1.33.1-db6

* NGINX config: Set client_max_body_size 0 to fix file upload issue
* README.md - Updated version numbers
* README.md - Added additional information
* GOALS.md - Tested numerous extensions and updated list
* LocalSettings_Extensions: Sorted configurations alphabetically
* LocalSettings_Extensions: Added config for ConfirmEdit
* LocalSettings_Extensions: Added config for Interwiki
* LocalSettings_Extensions: Added config for LocalisationUpdate
* LocalSettings_Extensions: Added config for OATHAuth
* LocalSettings_Extensions: Added config for TitleBlacklist
* LocalSettings_Extras: Sorted configurations alphabetically
* ExtensionManager: Added additional checks to prevent certain code from running if LocalSettings.php does not exist
* ExtensionManager: Added function to update database
* Cleaned up some whitespace in /root/cont-init.d/

## 2019-12-14 v1.33.1-db5

* Added additional information and changed links in README.md
* Added comment lines to Dockerfile
* Moved lines of code around in Dockerfile to prepare for MediaWiki 1.34+
* Added additional extensions that will be bundled with MediaWiki 1.34+
* Restructured version numbering
* Updated GOALS.md

## 2019-11-01 v1.33.1-db4 (never released)

* Enhanced **ExtensionManager** to support older extensions that use **require_once** to load
* Improved **ExtensionManager** integration with MediaWiki
* Now supports SQLite, MySQL, MariaDB, PostgreSQL *see KNOWNISSUES.md for issues regarding using MySQL and PostgreSQL*
* Added **Maintenance** extension
* Added email configuration **$wgSMTP** to LocalSettings_Extras.php
* Added additional information to README.md

## 2019-10-21 v1.33.1-db3

* *Changes to v1.33.1-db3 from v1.33.1-db2 may cause issues if updating the docker image*
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
* Updated README.md to reflect changes to use
* Added additional information to README.md
* Corrected several README.md typos
* Updated GOALS.md


## 2019-10-15 v1.33.1-db2

* Added poppler-utils fix for extension PdfHandler
* Fixed typo in cont-init.d script 15-config-wiki


## 2019-10-15 v1.33.1-db1

* Initial version
