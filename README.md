README

# Docker MediaWiki

[![DockerHub Pulls](https://img.shields.io/docker/pulls/d8sychain/mediawiki.svg)](https://hub.docker.com/r/d8sychain/mediawiki/) [![DockerHub Stars](https://img.shields.io/docker/stars/d8sychain/mediawiki.svg)](https://hub.docker.com/r/d8sychain/mediawiki/) [![GitHub Stars](https://img.shields.io/github/stars/d8sychain/docker-mediawiki.svg?label=github%20stars)](https://github.com/d8sychain/docker-mediawiki) [![GitHub Forks](https://img.shields.io/github/forks/d8sychain/docker-mediawiki.svg?label=github%20forks)](https://github.com/d8sychain/docker-mediawiki) [![GitHub License](https://img.shields.io/github/license/d8sychain/docker-mediawiki.svg)](https://github.com/d8sychain/docker-mediawiki)

[![MediaWiki](https://raw.githubusercontent.com/d8sychain/docker-mediawiki/master/assets/mediawiki-icon.png)](https://www.mediawiki.org)

Status: Beta

*I am considering this docker as beta for the time being. MediaWiki itself is fully functional and able to be used in a production environment, however, I have not tested / used all the extensions that are included with the core MediaWiki repository, meaning, some of the extensions may require additional libraries and/or additional configurations to function. See the documentation for a particular extension.*

Docker container for [MediaWiki](https://www.mediawiki.org) running on Alpine, with [Nginx](https://www.nginx.com), [PHP-FPM](https://php-fpm.org), [MediaWiki Parsoid](https://www.mediawiki.org/wiki/Parsoid) service, a CLI menu to simplify managing extensions, backups, and database updates, and *optional* [MariaDB](https://www.mariadb.org).

Based on LinuxServer.io custom base image [lsiobase/nginx:3.11](https://hub.docker.com/r/lsiobase/nginx/tags?page=1&name=3.10) built with Alpine, NGINX and S6 Overlay.

Packaged with the WYSIWYG [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) extension and its dependent [Parsoid](https://www.mediawiki.org/wiki/Parsoid) service along with other extensions.

This container is running 4 master processes: Nginx, PHP-FPM, Parsoid, Cron (5 if using optional MariaDB), each running their own child processes, supervised by [S6-overlay](https://github.com/just-containers/s6-overlay).

For a basic understanding of docker please refer to the official [documentation](https://docs.docker.com/).

The main focus of this docker was to build it in a way that makes it more convenient for [UnRaid](https://unraid.net/) users vs other dockers that are available. That's not to say that it can't be used on other host systems.


* [Supported Tags](#supported-tags)
* [Features](#features)
    * [Extensions](#extensions)
* [Changelog](#changelog)
* [Known Issues](#known-issues)
* [Getting Started](#getting-started)
    * [Database Options](#database-options)
	* [With UnRaid](#with-unraid)
	* [With SQLite](#with-sqlite)
	* [With MySQL](#with-mysql)
	* [With MariaDB](#with-mariadb)
	* [With PostgreSQL](#with-postgresql)
* [Parameters](#parameters)
* [HTTPS](#https)
* [Configuration](#configuration)
    * [Configuration files](#configuration-files)
	* [General](#general)
    * [Uploads](#uploads)
    * [Email](#email)
    * [Logo](#logo)
    * [Favicon](#favicon)
    * [Skins](#skins)
	* [Default User Options](default-user-options)
    * [Additional Extensions](#additional-extensions)
		* [Additional Instructions](#additional-instructions)
    * [Performance](#performance)
* [Managing Extensions With ExtensionManager](#managing-extensions-with-extensionmanager)
	* [Using ExtensionManager](using-extensionmanager)
	* [Adding An Extension](adding-an-extension)
	* [Removing An Extension](removing-an-extension)
	* [Updating The Database](updating-the-database)
	* [Upgrading An Extension](upgrading-an-extension)
* [Upgrading](#upgrading)
* [Contributing](#contributing)
* [Goals](#goals)
* [License](#license)


## Supported Tags

- `latest` Latest push to [(Master Branch)](https://github.com/d8sychain/docker-mediawiki/tree/master) - Alpine 3.11 - MW 1.34.0
- `1.33` Latest push to [(1.33 Branch)](https://github.com/d8sychain/docker-mediawiki/tree/1.33) - Alpine 3.11 - MW 1.33.2 *no longer developing as of Jan '20, may still recieve fixes from other branches or version bumps*
- `1.34` Latest push to [(1.34 Branch)](https://github.com/d8sychain/docker-mediawiki/tree/1.34) - Alpine 3.11 - MW 1.34.0
- `1.35` Latest push to [(1.35 Branch)](https://github.com/d8sychain/docker-mediawiki/tree/1.34) - Alpine 3.11 - MW 1.35 *ALPHA, stable expected June '20 see [MediaWiki version lifecycle](https://www.mediawiki.org/wiki/Version_lifecycle)*
- `vX.Y.Z-dbN` [Build Releases](https://github.com/d8sychain/docker-mediawiki/releases)

## Features

- [MediaWiki](https://www.mediawiki.org)
- [Nginx](https://www.nginx.com)
- [PHP-FPM](https://www.php.net/manual/en/book.fpm.php) with [PHP](https://www.mediawiki.org/wiki/Compatibility#PHP)
- [Parsoid](https://www.mediawiki.org/wiki/Parsoid) running on [NodeJS](https://nodejs.org)
- [SQLite](https://www.sqlite.org)
- [MariaDB](https://www.mariadb.org) *optional*
- [APCu](https://www.php.net/manual/en/book.apcu.php) PHP caching [*see MediaWiki Perfomance Tuning*](https://www.mediawiki.org/wiki/Manual:Performance_tuning#Object_caching)
- [International Components for Unicode](http://site.icu-project.org/) for Unicode normalization
- [Lua](http://www.lua.org)
- [ImageMagick](https://imagemagick.org/) for thumbnail generation
- [GNU Diffutils](https://www.gnu.org/software/diffutils/)
- Configured with [Short URLs](https://www.mediawiki.org/wiki/Manual:Short_URL)
- [ExtensionManager](#extensionmanager) for adding and removing extension
- Supports [SQLite](https://www.sqlite.org/index.html), [MySQL](https://www.mysql.com/), [MariaDB](https://mariadb.com/), [PostgreSQL](https://www.postgresql.org) databases
- For a complete list of installed packages and their version see [Package List](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/packages.list)

### Extensions
MediaWiki comes with a number of extensions bundled in by default since version 1.18.
Some extentions are additional extensions that were added to this docker.
Three additional extensions that were added will be bundled in by default in MediaWiki 1.34+

#### Special Pages
- [CiteThisPage](https://www.mediawiki.org/wiki/Extension:CiteThisPage)  (1.21+)
- [Interwiki](https://www.mediawiki.org/wiki/Extension:Interwiki) (1.21+)
- [Maintenance](https://www.mediawiki.org/wiki/Extension:Maintenance)  (Additional Extension)
- [Nuke](https://www.mediawiki.org/wiki/Extension:Nuke)  (1.18+)
- [Renameuser](https://www.mediawiki.org/wiki/Extension:Renameuser)  (1.18+)
- [Replace Text](https://www.mediawiki.org/wiki/Extension:Replace_Text)  (1.31+)
- [UserMerge](https://www.mediawiki.org/wiki/Extension:UserMerge)  (Additional Extension)

#### Editors
- [CodeEditor](https://www.mediawiki.org/wiki/Extension:CodeEditor)  (1.31+)
- [WikiEditor](https://www.mediawiki.org/wiki/Extension:WikiEditor)  (1.18+)
- [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor)  (Additional Extension)

#### Parser Hooks
- [CategoryTree](https://www.mediawiki.org/wiki/Extension:CategoryTree)  (1.31+)
- [Cite](https://www.mediawiki.org/wiki/Extension:Cite)  (1.21+)
- [ImageMap](https://www.mediawiki.org/wiki/Extension:ImageMap)  (1.21+)
- [InputBox](https://www.mediawiki.org/wiki/Extension:InputBox)  (1.21+)
- [ParserFunctions](https://www.mediawiki.org/wiki/Extension:ParserFunctions)  (1.18+)
- [Poem](https://www.mediawiki.org/wiki/Extension:Poem)  (1.21+)
- [Scribunto](https://www.mediawiki.org/wiki/Extension:Scribunto)  (additional extension will be bundled in future release MW 1.34+)
- [SyntaxHighlight](https://www.mediawiki.org/wiki/Extension:SyntaxHighlight)  (1.21+)
- [TemplateData](https://www.mediawiki.org/wiki/Extension:TemplateData)  (Additional Extension)
- [TemplateStyles](https://www.mediawiki.org/wiki/Extension:TemplateStyles)  (Additional Extension)

#### Media Handlers
- [PdfHandler](https://www.mediawiki.org/wiki/Extension:PdfHandler)  (1.21+)


#### Spam Prevention
- [ConfirmEdit](https://www.mediawiki.org/wiki/Extension:ConfirmEdit)  (1.18+)
- [SpamBlacklist](https://www.mediawiki.org/wiki/Extension:SpamBlacklist)  (1.21+)
- [TitleBlacklist](https://www.mediawiki.org/wiki/Extension:TitleBlacklist)  (1.21+)

#### API
- [PageImages](https://www.mediawiki.org/wiki/Extension:PageImages)  (additional extension will be bundled in future release MW 1.34+)

#### Other
- [Gadgets](https://www.mediawiki.org/wiki/Extension:Gadgets)  (1.18+)
- [LocalisationUpdate](https://www.mediawiki.org/wiki/Extension:LocalisationUpdate)  (1.21+)
- [MultimediaViewer](https://www.mediawiki.org/wiki/Extension:MultimediaViewer)  (1.31+)
- [OATHAuth](https://www.mediawiki.org/wiki/Extension:OATHAuth)  (1.31+)
- [TemplateWizard](https://www.mediawiki.org/wiki/Extension:TemplateWizard)  (Additional Extension)
- [TextExtracts](https://www.mediawiki.org/wiki/Extension:TextExtracts)  (additional extension will be bundled in future release MW 1.34+)
- [UploadWizard](https://www.mediawiki.org/wiki/Extension:UploadWizard)  (Additional Extension)


## Changelog

See [CHANGELOG.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CHANGELOG.md) for information about the latest changes.


## Known Issues

See [KNOWNISSUES.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/KNOWNISSUES.md) for information about current issues.


## Getting Started

Edit the container name, port numbers, variables, and host paths as needed.

You can also include `-v /path/to/store/file uploads:/assets` in the MediaWiki container to use an alternet storage location for file uploads in your wiki.

### Database Options

MediaWiki works with a number of databases, SQLite, MySQL, MariaDB, PostgreSQL, see [MediaWiki database compatibility](https://www.mediawiki.org/wiki/Manual:Installation_requirements#Database_server) for additional info.

**Note: Some extensions do not work with SQLite. It is possible to switch from SQLite to MySQL or MariaDB but that is beyond the scope of this documentation and support.**

If you are new to using a database or not sure what to use, MySQL or MariaDB is the recommended database for full compatibility with MediaWiki.

MySQL and MariaDB (forked from MySQL) are basically the same thing (research the difference, [Wikipedia uses MariaDB](https://en.wikipedia.org/wiki/Special:Version)).

This docker has SQLite built-in and the option to add MariaDB fully configured, providing a one-container-does-it-all approuch.

If you don't use one of the built in database options, then you also need to add a database docker container or have a database to connect too.

#### MariaDB add-on option

To use the MariaDB add-on option, add `-e MYSQL_INSTALL_OPTION=true` to the docker run command, or for UnRaid users, edit the template.

Setting MYSQL_INSTALL_OPTION to *true* will cause scripts to run during container startup that will, install MariaDB, initialize the databases, configure MariaDB, set root password and other options, and start the MySQL daemon.

**Note: If MYSQL_INSTALL_OPTION is not set to *true* or changed after databases are set up, the MySQL daemon will not start.**

**Note: Changing the MYSQL_ROOT_PASSWORD variable after the container has set up the initial databases has no effect, use the mysqladmin tool to change your MariaDB password.**

**Note: If you want to use (MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD) all three of these variables need to be set, you can not use just some of them.**

| Parameter | Function |
| :----: | --- |
| `-e MYSQL_INSTALL_OPTION=false` | Set this to `true` to install MariaDB and use it with-in this docker. Not needed if using an external database. |
| `-e MYSQL_ROOT_PASSWORD=ROOT_ACCESS_PASSWORD` | Set this to root password for installation (minimum 4 characters). If not set `ROOT_ACCESS_PASSWORD` will be used. |
| `-e MYSQL_DATABASE=USER_DB_NAME` | Optional: Specify the name of a database to be created on image startup. |
| `-e MYSQL_USER=MYSQL_USER` | Optional: This user will have superuser access to the database specified by MYSQL_DATABASE (do not use root here). |
| `-e MYSQL_PASSWORD=DATABASE_PASSWORD` | Optional: Set this to the password you want to use for you MYSQL_USER (minimum 4 characters). |

### With UnRaid

For users new to Docker on [UnRaid](https://unraid.net/) see [All about Docker in unRAID. Docker principles and setup](https://youtu.be/ISJczs06pD8?t=492) by [Spaceinvader One](https://www.youtube.com/channel/UCZDfnUn74N0WeAPvMqTOrtA). This video is a little old so most likely your UI will vary, but all of the information is still relevant. Also this link is skipped ahead starting with information about appdata and where docker will store appdata (MediaWiki and all of its configurations).

On UnRaid with the [Community Applications](https://forums.unraid.net/topic/38582-plug-in-community-applications/) plug-in use the **APPS** tab and search for `d8sychain mediawiki` then click install. Edit the template if needed and click **Apply**

### With SQLite

See [KNOWNISSUES.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/KNOWNISSUES.md) if using SQLite

Start the MediaWiki container and select SQLite during the MediaWiki installer

```
docker run --name=mediawiki_wiki \
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```

### With MySQL

See [KNOWNISSUES.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/KNOWNISSUES.md) if using MySQL 8+

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
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```

### With MariaDB

#### With one container-does-it-all

Start MediaWiki container.

```
docker run --name=mediawiki_wiki \
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-e MYSQL_INSTALL_OPTION=true \
-e MYSQL_ROOT_PASSWORD=root_password \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```

#### With multiple containers

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
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```

### With PostgreSQL

See [KNOWNISSUES.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/KNOWNISSUES.md) if using MediaWiki installer.

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
-p 9090:80 \
-e PUID=99 \
-e PGID=100 \
-v /path/to/store/mediawiki app data:/config \
-d d8sychain/mediawiki
```

You should be able to browse your wiki at [http://localhost:9090](http://localhost:9090) or `http://*server-ip*:9090`


## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 9090:80` | http |
| `-e PUID=99` | for UserID - see below for explanation. |
| `-e PGID=100` | for GroupID - see below for explanation. |
| `-e TZ="America/New_York"` | Specify a timezone to use. |
| `-e UPGRADE_MEDIAWIKI=disable` | Set this to *enable* to allow MediaWiki upgrades from newer docker images - see [Upgrading](#upgrading) for explanation. |
| `-e APK_UPGRADE=false` | Set this to *true* to **update** repository indexes from all remote repositories and **upgrade** currently installed packages to match repositories on each container start |
| `-v /config` | Contains your www content and all relevant configuration files. |
| **MariaDB add-on options** |
| `-e MYSQL_INSTALL_OPTION=false` | Set this to `true` to install MariaDB and use it with-in this docker. Not needed if using an external database. |
| `-e MYSQL_ROOT_PASSWORD=ROOT_ACCESS_PASSWORD` | Set this to root password for installation (minimum 4 characters). If not set `ROOT_ACCESS_PASSWORD` will be used. |
| `-e MYSQL_DATABASE=USER_DB_NAME` | Optional: Specify the name of a database to be created on image startup. |
| `-e MYSQL_USER=MYSQL_USER` | Optional: This user will have superuser access to the database specified by MYSQL_DATABASE (do not use root here). |
| `-e MYSQL_PASSWORD=DATABASE_PASSWORD` | Optional: Set this to the password you want to use for you MYSQL_USER (minimum 4 characters). |

### User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


## HTTPS

HTTPS is not configured within the container. Its recommended to use a nginx reverse proxy container for HTTPS setups. 

Recommend using Linuxserver.io Let's Encrypt [docker](https://hub.docker.com/r/linuxserver/letsencrypt). It has a built-in [Let's Encrypt](https://letsencrypt.org/) client that automates free SSL server certificate generation and renewal processes. It also contains fail2ban for intrusion prevention.

If you don't want to use a reverse proxy you can add your own cert and key to `/config/keys` and add the necessary configurations to `/config/nginx/nginx.conf`


## Configuration

From here on `/config` and `/assets` will refer to the host path that you mapped to each volumes.

### Configuration files

If any of these files, except for **LocalSettings.php**, becomes mis-configured and you can't fix it, just delete it and restart the container and the default file will be loaded back.

Note: When upgrading build versions, changes to configuration files will not override your current files.

* If you want the newest version of a config file, delete or rename your old file first.
* Then restart the container and the new config file will be added, then you can merge any customizations that you may have made in your original file.

**LocalSettings.php** is created/generated by the MediaWiki installer.

| Service | Path |
| :----: | --- |
| NGINX | `/config/nginx/nginx.conf` |
| PHP-FPM | `/config/php/php-fmp.conf` |
| PHP  | `/config/php/php.ini` |
| Parsoid | `/config/parsoid/config.yaml` |
| MediaWiki | `/config/www/mediawiki/LocalSettings.php` |
| MediaWiki | `/config/www/mediawiki/LocalSettings_Extras.php` |
| MediaWiki | `/config/www/mediawiki/LocalSettings_Extensions.php` |
| MariaDB | `/config/mysql/custom.cnf` (if using MariaDB add-on option) |

### General

* Use the MediaWiki installer to generate **LocalSettings.php** and save it to `/config/www/mediawiki`
* Restart the MediaWiki container `docker restart container_name` or for UnRaid use the UI to restart the container
* Make any customizations in **LocalSettings_Extras.php** and **LocalSettings_Extensions.php** These will be added after **LocalSettings.php** is saved to `/config/www/mediawiki` and the container is restarted.
* You may need to refresh the page and cache `Ctrl-F5` in your browser for the additional MediaWiki configurations to show
* There are several configurations in **LocalSettings_Extras.php** and **LocalSettings_Extensions.php** that are already defined but commented out
* Uncomment and modify them as needed and/or add your own

### Uploads

See [Manual:Configuring_file_uploads](https://www.mediawiki.org/wiki/Manual:Configuring_file_uploads) for more details on file uploads.

Uploads default to `/config/www/mediawiki/images/`

There are several configurations in **LocalSettings_Extras.php** for file uploads that are already defined but commented out

They include:

```
$wgEnableUploads = true;						// Enable uploads
$wgUploadPath = "/assets";						// Alternet path to file uploads. The URL of the upload directory.
$wgUploadDirectory = "/assets";						// Alternet path to file uploads. The file system path of the folder where uploaded files will be stored.
$wgUploadSizeWarning = 1073741824; // 1024*1024*1024 = 1 GB		// Maximum file upload size. If you increase this valve you must also update the config/php/php-local.ini file
$wgMaxUploadSize = 1073741824; // 1024*1024*1024 = 1 GB			// Maximum file upload size. If you increase this valve you must also update the config/php/php-local.ini file
$wgFileExtensions = array( 'png', 'gif', 'jpg', 'jpeg', 'doc',
    'xls', 'mpp', 'pdf', 'ppt', 'tiff', 'bmp', 'docx', 'xlsx',
    'pptx', 'ps', 'odt', 'ods', 'odp', 'odg'
);									// Allowed file extension types
$wgAllowCopyUploads = true;						// Uploading directly from a URLs
$wgCopyUploadsFromSpecialUpload = true;					// Uploading directly from a URLs
```

### Email

See MediaWiki [email configuration settings](https://www.mediawiki.org/wiki/Manual:Configuration_settings#Email_settings) for more details on email settings.

Enable Email is checked by default in the MediaWiki installer.

If you want to change whether Email is enabled, set **$wgEnableEmail** in **LocalSettings.php** to **true** or **false**

Configure your SMTP server settings in **LocalSettings_Extras.php**

```
$wgSMTP = [
    'host'     => "mail.example.com", 	// could also be an IP address. Where the SMTP server is located
    'IDHost'   => "example.com",      	// Generally this will be the domain name of your website (aka mywiki.org)
    'port'     => 25,                 	// Port to use when connecting to the SMTP server
    'auth'     => true,               	// Should we use SMTP authentication (true or false)
    'username' => "my_user_name",     	// Username to use for SMTP authentication (if being used)
    'password' => "my_password"       	// Password to use for SMTP authentication (if being used)
];
```


### Logo

You can setup your own logo by placing an image named **wiki.png** in `/config/www/mediawiki/resources/assets/wiki.png` or by placing a file within `/config/www/mediawiki` or in `/assets` (if using the optional docker volume for storing uploads) and changing [\$wgLogo](https://www.mediawiki.org/wiki/Manual:$wgLogo) in **LocalSettings.php** to this file

### Favicon

You can setup your own favicon by placing an image  **favicon.ico** in `/config/www/mediawiki/favicon.ico` or by placing a file within `/config/www/mediawiki` or in `/assets` (if using the optional docker volume for storing uploads) and changing [\$wgFavicon](https://www.mediawiki.org/wiki/Manual:$wgLogo) in **LocalSettings_Extras.php** to this file

### Skins

The default skins are packaged with MediaWiki:

* monobook
* timeless
* vector

You can add more [skins](https://www.mediawiki.org/wiki/Manual:Skins ) by downloading and adding them to `/confing/www/mediawiki/skins` and enable as per the skin's installation instructions. Add additional configurations to `/config/www/mediawiki/LocalSettings.php`

### Default User Options

See MediaWiki [Manual:$wgDefaultUserOptions](https://www.mediawiki.org/wiki/Manual:$wgDefaultUserOptions) for more details on Default User Options.

There is a few examples in **LocalSettings_Extras.php** that might commonly be used set with the default values.

```
$wgDefaultUserOptions['watchdefault'] = 1;		// Add pages the user edits to their watchlist, checking the "Watch this page" by default on all edited pages.
$wgDefaultUserOptions['date'] = 'default';		// Date format. Options: 'default', 'mdy', 'dmy', 'ymd', 'ISO 8601', 'persian'
$wgDefaultUserOptions['timecorrection'] = '0';		// A fixed timezone offset or ZoneInfo zone
```

### Additional Extensions

You can add more [extensions](https://www.mediawiki.org/wiki/Manual:Extensions ) by downloading and adding them to `/config/www/mediawiki/extensions` and enable as per the extension's installation instructions. Add additional configurations to `/config/www/mediawiki/LocalSettings_Extensions.php`

You can also use ExtensionManager *see [Managing Extensions With ExtensionManager](#adding-extensions-with-extensionmanager)*

#### Additional Instructions

There are some additional extensions that have been tested with this docker.

Some of them require special instructions, such as, Wikibase.

You can find them here, on github [/docs/instructions](https://github.com/d8sychain/docker-mediawiki/tree/master/docs/instructions)

If you would like to contribute instructions of your own for extensions that you've used, feel free to do so, and after reviewing, I'll add you to the contributors list.

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

This docker includes scripts for easing the adding and removal of extensions.

ExtensionManager can remove extensions that were not added using ExtensionManager, for example, if you wanted to remove one of the core extensions included with MediaWiki

If you add an extension using ExtensionManager and your wiki site won't load, just use ExtensionManager to remove it. Some extension just don't work with newer versions of MediaWiki.

In addition to adding and removing extensions, ExtensionManager can update the database schema, which is needed after adding some extensions.

### Using ExtensionManager

Edit file `/config/ExtensionManager/MANAGER`, add the operator **+**, **\***, or **-** and the extension's name (case sensitive) and/or **updatedb** per line.

You can add and remove as many extensions as you want, at once, in any combination.

For example:
```
+ContactPage
-AddMessages
+Poem
*ConfirmAccount
updatedb
```

The extension's name must be typed out exactly as it is named.

Then restart the container.

Or use `docker exec -it mediawiki_wiki /config/ExtensionManager/run` (*change mediawiki_wiki to the name of your container*)

Once an extension has been added it may require updating the database to add additional tables and/or additional configurations per the extension's documentation.

Link to the extension's documentation are added to **LocalSettings.php** along with the load command.

If additional configurations are needed, add them to **LocalSettings_Extensions.php**

### Adding An Extension

Check the extension's documentation first.

If the extension uses `wfLoadExtension( 'ExtensionName' );` to load it, use `+` and the extension's name. (newer)

If the extension uses `require_once "$IP/extensions/ExtensionName/ExtensionName.php";` to load it, use `*` and the extension's name. (older)

For example:
```
+ContactPage
+AddMessages
+Poem
*ConfirmAccount
```

### Removing An Extension

Use `-` and the extension's name.

For example:
```
-ContactPage
-AddMessages
-Poem
-ConfirmAccount
```

### Updating The Database

Some extensions require the database schema to be updated. Most extensions that require schema updates will say so in their documentation.

Use `updatedb` to run the MediaWiki **update.php** script.

For example:
```
*ConfirmAccount
updatedb
```

**Warning: update.php may exit with errors, leaving the database in an inconsistent state. Always backup the database before running the script!**

See https://www.mediawiki.org/wiki/Manual:Update.php for additional information on update.php

### Upgrading An Extension

ExtensionManager maintains a list of all currently added extensions by ExtensionManager.

When upgrading to a newer version of MediaWiki with newer docker images, the upgrade scripts will automatically upgrade your additional extensions based on this list.

### Repairing or Manually Upgrading An Extension

You can remove and add the same extension at the same time.

This removes all of the extension's files and re-adds them.

It will not effect any additional configurations for the extension that you may have added or set in **LocalSettings_Extensions.php**.

Use `-` and the extension's name then

Use `+` or `*` and the extension's name.

For example:
```
-ContactPage
+ContactPage
```


## Upgrading

It is highly recommended that you **maintain a backup of your database** before enabling upgrading. (*you should maintain a backup of your database anyways*)

If using SQLite or built-in MariaDB add-on with MediaWiki the database will be backed up along with MediaWiki if using the default database directory.

If using tag `latest`, it will have the newest packages installed. See `/config/log/package.list` for a list of installed packages and their versions.

As MediaWiki continues to develop, newer versions of this docker image will be released. 

A newer docker image may contain a newer version of MediaWiki and the image will automatically backup MediaWiki, upgrade it and the database, if environment variable **UPGRADE_MEDIAWIKI** is set to **enable**. 

The default is set to **disable**.

Add `-e UPGRADE_MEDIAWIKI=enable` to your docker run command.

Or if your using UnRaid edit the template.

Note: When upgrading build versions, changes to configuration files will not override your current files.

* If you want the newest version of a config file, delete or rename your old file first.
* Then restart the container and the new config file will be added, then you can merge any customizations that you may have made in your original file.


## Contributing

See [CONTRIBUTING.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CONTRIBUTING.md) for information on how to contribute to the project.

See [CONTRIBUTORS.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CONTRIBUTORS.md) for the list of contributors.


## Goals

See [GOALS.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/GOALS.md) for information on future for the project.


## License

This project is licensed under the GPLv3.
