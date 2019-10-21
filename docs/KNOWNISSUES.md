KNOWNISSUES

# Docker MediaWiki

* Updating from docker 1.33-2 or older to 1.33-3 may cause issues
	* If you have completed the installer already and started using MediaWiki
	* Delete the following files: **/config/www/mediawiki/ExtraLocalSettings.php** and **/config/nginx/nginx.conf**
	* Remove line 163 **# Load extra settings** and line 164 **require ExtraLocalSettings.php';** from **LocalSettings.php**
	* Restart the container.