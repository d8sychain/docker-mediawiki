KNOWNISSUES

# This MediaWiki docker

* Updating from image v1.33-db2 or older to v1.33-db3+ may cause issues
	* These changes are not automated incase of any customizations that you may have made to the mentioned files and need to be retained.
	* If you have completed the installer already and started using MediaWiki
	* Delete or rename the following files: **/config/www/mediawiki/ExtraLocalSettings.php** and **/config/nginx/nginx.conf** 
	* Remove line 163 **# Load extra settings** and line 164 **require ExtraLocalSettings.php';** from **LocalSettings.php**
	* Restart the container.
* I have noticed occasional that VisualEditor will not load and returns an error. This may be due to an issue with caching, https://www.mediawiki.org/wiki/Topic:Ueycowwi66jadub1  I have not tested this.
	
# MediaWiki using MySQL 8+ docker

* MediaWiki can not connect/authenticate to MySQL 8.0.4 and above with new installations of MySQL
	* As of MySQL 8.0.4, MySQL changed the default Authentication Plugin https://mysqlserverteam.com/mysql-8-0-4-new-default-authentication-plugin-caching_sha2_password/ 
	* Known work around:
		* Add MySQL with an older version pre v8.0.4 then upgrade MySQL if want the latest version
		* **OR**
		* Create a text file in a new directory on the host ***mysql/docker/config/myconfig*.cnf**
		* insert:
			```	
			[mysqld]
			default_authentication_plugin    = mysql_native_password
			```
		* Change the file permissions for ***myconfig*.cnf**, if global has write permission MySQL will ignore the file
		* Add MySQL and  volume map the new directory to Container Path: **/etc/mysql/conf.d**
		* Also see https://forums.unraid.net/topic/84304-support-d8sychain-mediawiki/?tab=comments#comment-783962 for related info.
					
# MediaWiki using PostgreSQL docker

* Installer does not respect initial DBport declaration https://phabricator.wikimedia.org/T30162
	* When using the MediaWiki installer it will default to the default database port number 5432 regardless of what port number you enter
	* Known work around:
		* Use the database default port number 5432, use the MediaWiki installer, then after completing the installation change the database port number to what you want it to be and edit the MediaWiki LocalSettings.php setting '$wgDBport = "value";' to match your setup