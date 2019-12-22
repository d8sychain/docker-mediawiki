# Add Notifications
* Various extensions can be added to enhance notifications in MediaWiki.
* The following is only compatible with MySQL or MariaDB databases.

## Echo https://www.mediawiki.org/wiki/Extension:Echo (required for the other extensions listed)
### This extension provides an in-wiki notification system that can be used by other extensions.
* Use the ExtensionManager (see README.md)
* Add
	```
	+Echo
	updatedb
	```
	to **/config/ExtensionManager/MANAGER**
* Restart the docker container or use `docker exec -it testwiki /config/ExtensionManager/run`

## LoginNotify https://www.mediawiki.org/wiki/Extension:LoginNotify
### This extension notifies you when someone logs into your account. It can be configured to give warnings after a certain number of failed login attempts.
* Use the ExtensionManager (see README.md)
* Add
	```
	+LoginNotify
	```
	to **/config/ExtensionManager/MANAGER**
* Restart the docker container or use `docker exec -it testwiki /config/ExtensionManager/run`

## Thanks https://www.mediawiki.org/wiki/Extension:Thanks
### It allows users to send public 'thank you' notifications (via Echo) to other users for their individual edits and some logged actions.
* Use the ExtensionManager (see README.md)
* Add
	```
	+Thanks
	```
	to **/config/ExtensionManager/MANAGER**
* Restart the docker container or use `docker exec -it testwiki /config/ExtensionManager/run`