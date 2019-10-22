README

# Docker MediaWiki

[![DockerHub Pulls](https://img.shields.io/docker/pulls/d8sychain/mediawiki.svg)](https://hub.docker.com/r/d8sychain/mediawiki/) [![DockerHub Stars](https://img.shields.io/docker/stars/d8sychain/mediawiki.svg)](https://hub.docker.com/r/d8sychain/mediawiki/) [![GitHub Stars](https://img.shields.io/github/stars/d8sychain/docker-mediawiki.svg?label=github%20stars)](https://github.com/d8sychain/docker-mediawiki) [![GitHub Forks](https://img.shields.io/github/forks/d8sychain/docker-mediawiki.svg?label=github%20forks)](https://github.com/d8sychain/docker-mediawiki) [![GitHub License](https://img.shields.io/github/license/d8sychain/docker-mediawiki.svg)](https://github.com/d8sychain/docker-mediawiki)

[![MediaWiki](https://raw.githubusercontent.com/d8sychain/docker-mediawiki/master/assets/mediawiki-icon.png)](https://www.mediawiki.org)

Status: Beta

*I am considering this docker as beta for the time being. MediaWiki itself is fully functional and able to be used in a production environment, however, I have not tested / used all the extensions that are included with the core MediaWiki repository, meaning, some of the extensions may require additional libraries and/or additional configurations to function. See the documentation for a particular extension.*

Docker container for [MediaWiki](https://www.mediawiki.org) running under [Nginx](https://www.nginx.com) and [PHP-FPM](https://php-fpm.org/) with [Parsoid](https://www.mediawiki.org/wiki/Parsoid) service.

Based on LinuxServer.io custom base image [lsiobase/nginx:3.10](https://hub.docker.com/r/lsiobase/nginx/tags?page=1&name=3.10) built with Alpine linux, nginx and S6 overlay.

Packaged with the WYSIWYG [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) extension and its dependent [Parsoid](https://www.mediawiki.org/wiki/Parsoid) service along with other extensions.

This container is running 4 master processes (Nginx, PHP-FPM, Parsoid, Cron), each running their own child processes, supervised by [S6-overlay](https://github.com/just-containers/s6-overlay).

For a basic understanding of docker please refer to the official [documentation](https://docs.docker.com/).

The main focus of this docker was to build it in a way that makes it more convenient for [UnRaid](https://unraid.net/) users vs other dockers that are available. That's not to say that it can't be used on other host systems.


* [Supported Tags](#supported-tags)
* [Features](#features)
    * [Extensions](#extensions)
* [Changelog](#changelog)
* [Known Issues](#known-issues)
* [Getting Started](#getting-started)
    * [With UnRaid](#with-unraid)
	* [With SQLite](#with-sqlite)
	* [With MySQL](#with-mysql)
	* [With MariaDB](#with-mariadb)
	* [With PostgreSQL](#with-postgresql)
* [HTTPS](#https)
* [Configuration](#configuration)
    * [Configuration files](#configuration-files)
	* [General](#general)
    * [Uploads](#uploads)
    * [E-Mail](#e-mail)
    * [Logo](#logo)
    * [Favicon](#favicon)
    * [Skins](#skins)
    * [Additional Extensions](#additional-extensions)
    * [Performance](#performance)
* [Managing Extensions With ExtensionManager](#managing-extensions-with-extensionmanager)
* [Upgrading](#upgrading)
* [Contributing](#contributing)
* [License](#license)


## Supported Tags

- `latest` [(Dockerfile)](https://github.com/d8sychain/docker-mediawiki/blob/master/Dockerfile)
- `1.33` [(Dockerfile)](https://github.com/d8sychain/docker-mediawiki/blob/1.33/Dockerfile)
- `1.34` [Expected late Nov '19](https://github.com/d8sychain/docker-mediawiki/blob/1.34/Dockerfile)


## Features

- [MediaWiki](https://www.mediawiki.org) 1.33.1
- [Nginx](https://www.nginx.com) 1.16.1
- [PHP-FPM](https://www.php.net/manual/en/book.fpm.php) with [PHP](https://www.mediawiki.org/wiki/Compatibility#PHP) 7.3.8
- [Parsoid](https://www.mediawiki.org/wiki/Parsoid) running on [NodeJS](https://nodejs.org) 10.16.3
- [APCu](https://www.php.net/manual/en/book.apcu.php) PHP caching [*see MediaWiki Perfomance Tuning*](https://www.mediawiki.org/wiki/Manual:Performance_tuning#Object_caching)
- [International Components for Unicode](http://site.icu-project.org/) 64.2 for Unicode normalization
- [Lua](http://www.lua.org) 5.1
- [ImageMagick](https://imagemagick.org/) for thumbnail generation
- [GNU Diffutils](https://www.gnu.org/software/diffutils/)
- Configured with [Short URLs](https://www.mediawiki.org/wiki/Manual:Short_URL)
- [ExtensionManager](#extensionmanager) for adding and removing extension
- Supports [SQLite](https://www.sqlite.org/index.html), [MySQL](https://www.mysql.com/), [MariaDB](https://mariadb.com/), [PostgreSQL](https://www.postgresql.org) databases

### Extensions
Extensions that are part of the core MediaWiki are marked.

#### Special Pages
- [Interwiki](https://www.mediawiki.org/wiki/Extension:Interwiki) **core*
- [CiteThisPage](https://www.mediawiki.org/wiki/Extension:CiteThisPage)  **core*
- [Replace Text](https://www.mediawiki.org/wiki/Extension:Replace_Text)  **core*
- [Renameuser](https://www.mediawiki.org/wiki/Extension:Renameuser)  **core*
- [UserMerge](https://www.mediawiki.org/wiki/Extension:UserMerge)

#### Editors
- [CodeEditor](https://www.mediawiki.org/wiki/Extension:CodeEditor)  **core*
- [WikiEditor](https://www.mediawiki.org/wiki/Extension:WikiEditor)  **core*
- [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor)

#### Parser Hooks
- [CategoryTree](https://www.mediawiki.org/wiki/Extension:CategoryTree)  **core*
- [Cite](https://www.mediawiki.org/wiki/Extension:Cite)  **core*
- [ImageMap](https://www.mediawiki.org/wiki/Extension:ImageMap)  **core*
- [InputBox](https://www.mediawiki.org/wiki/Extension:InputBox)  **core*
- [ParserFunctions](https://www.mediawiki.org/wiki/Extension:ParserFunctions)  **core*
- [Scribunto](https://www.mediawiki.org/wiki/Extension:Scribunto)
- [SyntaxHighlight](https://www.mediawiki.org/wiki/Extension:SyntaxHighlight)  **core*
- [TemplateData](https://www.mediawiki.org/wiki/Extension:TemplateData)
- [TemplateStyles](https://www.mediawiki.org/wiki/Extension:TemplateStyles)

#### Media Handlers
- [PdfHandler](https://www.mediawiki.org/wiki/Extension:PdfHandler)  **core*
- [MultimediaViewer](https://www.mediawiki.org/wiki/Extension:MultimediaViewer)  **core*
- [UploadWizard](https://www.mediawiki.org/wiki/Extension:UploadWizard)  


## Changelog

See [CHANGELOG.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CHANGELOG.md) for information about the latest changes.


## Known Issues

See [KNOWNISSUES.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/KNOWNISSUES.md) for information about current issues.


## Getting Started

Edit the container name, port numbers, variables, and host paths as needed.

You can also include `-v /path/to/store/file uploads:/assets` in the MediaWiki container to use an alternet storage location for file uploads in your wiki.

### With UnRaid

For users new to Docker on [UnRaid](https://unraid.net/) see [All about Docker in unRAID. Docker principles and setup](https://youtu.be/ISJczs06pD8?t=492) by [Spaceinvader One](https://www.youtube.com/channel/UCZDfnUn74N0WeAPvMqTOrtA). This video is a little old so most likely your UI will vary, but all of the information is still relevant. Also this link is skipped ahead starting with information about appdata and where docker will store appdata (MediaWiki and all of its configurations).

On UnRaid with the [Community Applications](https://forums.unraid.net/topic/38582-plug-in-community-applications/) plug-in use the **APPS** tab and search for `d8sychain mediawiki` then click install. Edit the template if needed and click **Apply**

If you are not using SQLite then you also need to add a MySQL, MariaDB or PostgreSQL docker container. (recommended for large databases)

### With SQLite

Start the MediaWiki container and select SQLite during the MediaWiki installer

```
docker run --name=mediawiki_wiki \
--link mediawiki_mysql:mediawiki_mysql \
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```

### With MySQL

Start a MySQL container.

```
docker run --name mediawiki_db \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root_password \
-v /path/to/store/database:/var/lib/mysql \
-d mysql
```

Start MediaWiki container.

```
docker run --name=mediawiki_wiki \
--link mediawiki_mysql:mediawiki_mysql \
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```

### With MariaDB

Start a MariaDB container.

```
docker run --name mediawiki_db \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root_password \
-v /path/to/store/database:/var/lib/mysql \
-d mariadb
```

Start MediaWiki container.

```
docker run --name=mediawiki_wiki \
--link mediawiki_mysql:mediawiki_mysql \
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```

### With PostgreSQL

Start a PostgreSQL container.

```
docker run --name mediawiki_db \
-p 5432:5432 \
-e POSTGRES_USER=root \
-e POSTGRES_PASSWORD=root_password \
-e POSTGRES_DB=mediawiki \
-v /path/to/store/database:/var/lib/postgresql/data \
-d postgresql:11
```

Start MediaWiki container.

```
docker run --name=mediawiki_wiki \
--link mediawiki_mysql:mediawiki_mysql \
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```


You should be able to browse your wiki at [http://localhost:9090](http://localhost:9090) or `http://*server-ip*:9090`


## HTTPS

HTTPS is not configured within the container. Its recommended to use a nginx reverse proxy container for HTTPS setups. 

Recommend using Linuxserver.io Let's Encrypt [docker](https://hub.docker.com/r/linuxserver/letsencrypt). It has a built-in [Let's Encrypt](https://letsencrypt.org/) client that automates free SSL server certificate generation and renewal processes. It also contains fail2ban for intrusion prevention.

If you don't want to use a reverse proxy you can add your own cert and key to `/config/keys` and add the necessary configurations to `/config/nginx/nginx.conf`


## Configuration

From here on `/config` and `/assets` will refer to the host path that you mapped to each volumes.

### Configuration files

If any of these files, except for **LocalSettings.php**, becomes mis-configured and you can't fix it, just delete it and restart the container and the default file will be loaded back.

**LocalSettings.php** is created by the MediaWiki installer.

- NGINX `/config/nginx/nginx.conf`
- PHP-FPM `/config/php/php-fmp.conf`
- PHP `/config/php/php.ini`
- Parsoid `/config/parsoid/config.yaml`
- MediaWiki `/config/www/mediawiki/LocalSettings.php`
- MediaWiki `/config/www/mediawiki/LocalSettings_Extras.php`
- MediaWiki `/config/www/mediawiki/LocalSettings_Extensions.php`

### General

* Use the MediaWiki installer to generate **LocalSettings.php** and save it to `/config/www/mediawiki`
* Restart the MediaWiki container `docker restart container_name` or for UnRaid use the UI to restart the container
* Make any customizations in **LocalSettings_Extras.php** and **LocalSettings_Extensions.php** These will be added after **LocalSettings.php** is saved to `/config/www/mediawiki` and the container is restarted.
* You may need to refresh the page and cache `Ctrl-F5` in your browser for the additional MediaWiki configurations to show
* There are several configurations in **LocalSettings_Extras.php** and **LocalSettings_Extensions.php** that are already defined but commented out
* Uncomment and modify them as needed and/or add your own

### Uploads

Uploads default to `/config/www/mediawiki/images/`

There are several configurations in **LocalSettings_Extras.php** for file uploads that are already defined but commented out

They include:

```
## File Uploads
## See https://www.mediawiki.org/wiki/Manual:Configuring_file_uploads
#$wgEnableUploads = true; # Enable uploads
// Uncomment below to use docker volume /assets upload path or set your own path
#$wgUploadPath = "/assets";
#$wgUploadDirectory = "/assets";
// Maximum file upload size
// If you increase this valve you must also update the config/php/php-local.ini file
#$wgUploadSizeWarning = 1073741824; // 1024*1024*1024 = 1 GB
#$wgMaxUploadSize = 1073741824; // 1024*1024*1024 = 1 GB
// Allowed file extension types
#$wgFileExtensions = array( 'png', 'gif', 'jpg', 'jpeg', 'doc',
#    'xls', 'mpp', 'pdf', 'ppt', 'tiff', 'bmp', 'docx', 'xlsx',
#    'pptx', 'ps', 'odt', 'ods', 'odp', 'odg'
#);
// Uploading directly from a URLs
#$wgAllowCopyUploads = true;
#$wgCopyUploadsFromSpecialUpload = true;
```

### E-Mail

Not setup/tested. May be missing necessary libs or it may just work as is. *Plan to include in a future build*


### Logo

You can setup your own logo by placing an image named **wiki.png** in `/config/www/mediawiki/resources/assets/wiki.png` or by placing a file within `/config/www/mediawiki` or in `/assets` (if using the optional docker volume for storing uploads) and changing [\$wgLogo](https://www.mediawiki.org/wiki/Manual:$wgLogo) in **LocalSettings.php** to this file

### Favicon

You can setup your own favicon by placing an image  **favicon.ico** in `/config/www/mediawiki/favicon.ico` or by placing a file within `/config/www/mediawiki` or in `/assets` (if using the optional docker volume for storing uploads) and changing [\$wgFavicon](https://www.mediawiki.org/wiki/Manual:$wgLogo) in **LocalSettings_Extras.php** to this file

### Skins

The default skins are packaged with MediaWiki:

* monobook
* timeless
* vector

You can add more [skins](https://www.mediawiki.org/wiki/Manual:Skins) by downloading and adding them to `/confing/www/mediawiki/skins` and enable as per the skin's installation instructions. Add additional configurations to `/config/www/mediawiki/LocalSettings.php`

### Additional Extensions

You can add more [extensions](https://www.mediawiki.org/wiki/Manual:Skins) by downloading and adding them to `/config/www/mediawiki/extensions` and enable as per the extension's installation instructions. Add additional configurations to `/config/www/mediawiki/LocalSettings_Extensions.php`

You can also use ExtensionManager *see [Managing Extensions With ExtensionManager](#adding-extensions-with-extensionmanager)*

### Performance

The container has some performance related configuration options. If you have more advanced needs you can override the configurations by editing configuration files. If you accidently break one of the configuration files, just delete it and restart the container and it will automatically be replaced with the default.

- NGINX `/config/nginx/wiki-nginx.conf`
    - line 3 `worker_processes 4` 
- PHP-FPM `/config/php/php-fmp.conf`
    - line 23 `pm = dynamic`
    - line 24 `pm.max_children = 75`
    - line 25 `pm.start_servers = 1`
    - line 26 `pm.min_spare_servers = 1`
    - line 27 `pm.max_spare_servers = 20`
    - line 28 `pm.max_requests = 500`
- Parsoid `/config/parsoid/config.yaml`
    - line 2 `num_workers: 4`
	

## Managing Extensions With ExtensionManager

*This does not work for all extensions especially older ones. Check the extension documentation first, if the extension uses `require_once "$IP/extensions/ExtensionName/ExtensionName.php";` to load it, then do not use ExtensionManager, instead, download the the extension manually to `/config/www/mediawiki/extensions/ExtensionName`. If you add an extension using ExtensionManager and your wiki site won't load, just use ExtensionManager to remove it and try adding it manually per the extension's documentation. I may expand the functionality of ExtensionManager later on to make it usable with older extensions.*

This docker includes scripts for easing the adding and removal of extensions.

ExtensionManager can remove extensions that were not added using ExtensionManager, for example, if you wanted to remove one of the core extensions included with MediaWiki

### Using ExtensionManager

Edit file `/config/ExtensionManager/MANAGER`, add the operator **+** or **-** and extension's name per line.

You can add and remove as many extensions as you want at once in any combination.

For example:
```
+ContactPage
-AddMessages
+Poem
-LinkTarget
```

The extension's name must be typed out exactly as it is named.

Then restart the container.

Or use `docker exec -it mediawiki_wiki /config/ExtensionManager/run` (*change mediawiki_wiki to the name of your container*)

Once an extension has been added it may require additional configurations per the extension's documentation.

If additional configurations are needed, add them to **LocalSettings_Extensions.php**

### Adding An Extension

Use `+` and the extension's name.

For example:
```
+ContactPage
+AddMessages
+Poem
+LinkTarget
```

### Removing An Extension

Use `-` and the extension's name.

For example:
```
-ContactPage
-AddMessages
-Poem
-LinkTarget
```

### Upgrading An Extension

ExtensionManager maintains a list of all currently added extensions by ExtensionManager.

When upgrading to a newer version of MediaWiki with newer docker images, the upgrade scripts will automatically upgrade your additional extensions based on this list.

### Repairing or Manually Upgrading An Extension

You can remove and add the same extension at the same time.

This removes all of the extension's files and re-adds them.

It will not effect any additional configurations for the extension that you may have added or set in **LocalSettings_Extensions.php**.

Use `-` and the extension's name then

Use `+` and the extension's name.

For example:
```
-ContactPage
+ContactPage
```


## Upgrading

It is highly recommended that you **maintain a backup of your database** before enabling upgrading. (*you should maintain a backup of your database anyways*)

If using SQLite with MediaWiki the database will be backed up along with MediaWiki if using the default database directory.

If using tag `latest`, it will have the newest packages installed. See `/config/log/package.list` for a list of installed packages and their versions.

As MediaWiki continues to develop, newer versions of this docker image will be released. 

A newer docker image may contain a newer version of MediaWiki and the image will automatically backup MediaWiki, upgrade it and the database, if environment variable **UPGRADE_MEDIAWIKI** is set to **enable**. 

The default is set to **disable**.

Add `-e UPGRADE_MEDIAWIKI=enable` to your docker run command.

Or if your using UnRaid edit the template.


## Contributing

See [CONTRIBUTING.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CONTRIBUTING.md) for information on how to contribute to the project.

See [CONTRIBUTORS.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CONTRIBUTORS.md) for the list of contributors.


## License

This project is licensed under the GPLv3.
