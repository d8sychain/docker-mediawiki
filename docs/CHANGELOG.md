CHANGELOG

# Docker MediaWiki
* Note: Changes to configuration files will not override your current files.
	* If you want the newest version of a config file, delete or rename your old file first.
	* Then restart the container and the new config file will be added, then you can merge any customizations that you may have made in your original file.


## 2020-02-09
* Bumping to Alpine v3.11 (lsiobase/nginx:3.11)
	* This will also upgrade numerous Alpine packages
* Dockerfile: Added htop package
* Renamed files
	* /etc/cont-init.d/15-config-wiki        > 14-config-wiki
	* /etc/cont-init.d/17-extension-manager  > 18-extension-manager
* Added option to add MariaDB(MySQL) built into the container, providing a one-container-does-all (***NEW FEATURE***)
	* Dockerfile: Added additional ENV variables
	* Added new files:
		* /defaults/mysql/default.cnf
		* /etc/cont-init.d/22-config-db
		* /etc/cont-init.d/24-initialize-db
		* /etc/services.d/mariadb/run
	* 16-upgrade: Added temporary start of mysqld to run MediaWiki maintenance script update.php during MediaWiki upgrade if using the MariaDB add-in
* Merged /etc/cont-init.d/14-upgrade code into 16-upgrade
* MediaWiki Maintenance CLI Menu (***NEW FEATURE***)
	* Extension management
	* Backup management
	* Database management
	* Services management
* ExtensionManager (***ENHANCED FEATURE***)
	* Moved various code in to functions in extension-manager.func for added flexibility
	* Added additional functions to extension-manager.func
	* Added error checking for trying to add non existent extension names 
	* Changed /etc/cont-init/18-extension-manager to call functions
* Backup functions (***NEW FEATURE***)
	* Perform various backups
	* Option to call various backup functions on each container start
	* Restore and remove existing backups
	* Remove existing backups by age
	* Rename backups
	* Ability to schedule backup functions with crontabs
	* Dockerfile: Added additional ENV variables
	* Added new files
		* /etc/cont-init.d/12-backup
		* /etc/cron-backups.d/backup_all
		* /etc/cron-backups.d/backup_assets
		* /etc/cron-backups.d/backup_configs
		* /etc/cron-backups.d/backup_data
		* /etc/cron-backups.d/backup_remove_old
		* /etc/cron-backups.d/backup_wiki
		* /etc/mw-maintenance.d/backup.func
* Database functions (***NEW FEATURE***)
	* Lock and unlock database
	* Update database schema
* Services functions (***NEW FEATURE***)
	* Edit configuration files
	* View log files
	* Follow log files live
	* Restart services
	* View running processes with htop
* MediaWiki file upload, logo, favicon settings changed
	* Changed NGINX config/default/nginx/wiki-nginx.conf
	* 14-config-wiki: Added code to comment out $wgLogo in LocalSettings.php
	* LocalSettings_Extras.php: Set new default $wgUploadPath and $wgUploadDirectory
	* LocalSettings_Extras.php: Set new default wgLogo and $wgFavicon
* Added pid file to php-fpm config
* 14-config-wiki: Setup parsoid config file as a symlink instead of copying
* Added /etc/cont-init/08-apklist to update apk package list before start of other scripts
* Updated UnRaid template for mediawiki:latest
* Added UnRaid template for mediawiki:edge
* README.md: Added additional information
* README.md: Removed apk package version numbers, but added link to package list
* KNOWNISSUES.md: Added and updated information
* GOALS.md - Updated

## 2019-12-22 v1.33.2-db7
* Bumping MediaWiki to v1.33.2
* Dockerfile: Added ENV MEDIAWIKI_VERSION
* 14-upgrade: Changed some environment variables related to version numbering
* 16-upgrade: Changed some environment variables related to version numbering
* Dockerfile: Added php7-tokenizer package needed for Composer
* Dockerfile: Added lua package needed for Scribunto extension
* 15-config-wiki: Added log folder for Lua
* LocalSettings_Extensions: Added additional configs for Scribunto/Lua
* LocalSettings_Extras: Added additional config needed for URL file uploads
* 15-config-wiki: Added test to run composer on TemplateStyles if needed
* Added instructions section to docs (intended to be mostly instructions for adding specific features/extensions to this docker)
* Dockerfile: Added TemplateWizard
* LocalSettings_Extensions: Added configs for CheckUser (extension not included)
* Moved Gadget config from LocalSettings_Extras.php to LocalSettings_Extensions.php
* Cleaned up readability in code
* README.md: Updated version numbers
* README.md: Added extension TemplateWizard to list
* README.md: Added additional information
* KNOWNISSUES.md: Updated information
* GOALS.md - Tested additional extensions and updated list


## 2019-12-17 v1.33.1-db6

* NGINX config: Set client_max_body_size 0 to fix file upload issue
* README.md: Updated version numbers
* README.md: Added additional information
* GOALS.md: Tested numerous extensions and updated list
* LocalSettings_Extensions: Sorted configurations alphabetically
* LocalSettings_Extensions: Added config for ConfirmEdit
* LocalSettings_Extensions: Added config for Interwiki
* LocalSettings_Extensions: Added config for LocalisationUpdate
* LocalSettings_Extensions: Added config for OATHAuth
* LocalSettings_Extensions: Added config for TitleBlacklist
* LocalSettings_Extras: Sorted configurations alphabetically
* ExtensionManager: Added additional checks to prevent certain code from running if LocalSettings.php does not exist
* ExtensionManager: Added function to update database
* Cleaned up some whitespace in /etc/cont-init.d/

## 2019-12-14 v1.33.1-db5

* Added additional information and changed links in README.md
* Added comment lines to Dockerfile
* Moved lines of code around in Dockerfile to prepare for MediaWiki 1.34+
* Added additional extensions that will be bundled with MediaWiki 1.34+
* Restructured docker build version numbering
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
* Developed and added **ExtensionManager** to simply adding or removing extensions (***NEW FEATURE***)
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
* Fixed typo in /etc/cont-init.d/15-config-wiki


## 2019-10-15 v1.33.1-db1

* Initial version
