README

# Docker MediaWiki

[![DockerHub Pulls](https://img.shields.io/docker/pulls/d8sychain/mediawiki.svg)](https://hub.docker.com/r/d8sychain/mediawiki/) [![DockerHub Stars](https://img.shields.io/docker/stars/d8sychain/mediawiki.svg)](https://hub.docker.com/r/d8sychain/mediawiki/) [![GitHub Stars](https://img.shields.io/github/stars/d8sychain/docker-mediawiki.svg?label=github%20stars)](https://github.com/d8sychain/docker-mediawiki) [![GitHub Forks](https://img.shields.io/github/forks/d8sychain/docker-mediawiki.svg?label=github%20forks)](https://github.com/d8sychain/docker-mediawiki) [![GitHub License](https://img.shields.io/github/license/d8sychain/docker-mediawiki.svg)](https://github.com/d8sychain/docker-mediawiki)

[![MediaWiki](https://raw.githubusercontent.com/d8sychain/docker-mediawiki/master/assets/mediawiki-icon.png)](https://www.mediawiki.org)

Status: Beta

*I am considering this docker as beta for the time being. Mediawiki itself is fully functional and able to be used in a production environment, however, I have not tested / used all the extensions that are included with the core Mediawiki repository. Some of the extensions may require additional libraries and/or additional configurations to function. See the documentation for a particular extension.*

Docker container for [MediaWiki](https://www.mediawiki.org) running under [Nginx](https://www.nginx.com) and [PHP-FPM](https://php-fpm.org/) with [Parsoid](https://www.mediawiki.org/wiki/Parsoid) service.

Based on LinuxServer.io custom base image [lsiobase/nginx:3.10](https://hub.docker.com/r/lsiobase/nginx/tags?page=1&name=3.10) built with Alpine linux, nginx and S6 overlay.

Packaged with the WYSIWYG [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) extension and its dependant [Parsoid](https://www.mediawiki.org/wiki/Parsoid) service along with other extensions.

This container is running 4 master processes (Nginx, PHP-FPM, Parsoid, Cron), each runing thier own child processes, supervised by [S6-overlay](https://github.com/just-containers/s6-overlay).

For a basic understanding of docker please refer to the official [documentation](https://docs.docker.com/).

* [Supported Tags](#supported-tags)
* [Features](#features)
    * [Extensions](#extensions)
* [Changelog](#changelog)
* [Known Issues](#known-issues)
* [Usage](#usage)
    * [With MySQL](#with-mysql)
* [HTTPS](#https)
* [Configuration](#configuration)
    * [General](#general)
    * [Uploads](#uploads)
    * [E-Mail](#e-mail)
    * [Logo](#logo)
    * [Favicon](#favicon)
    * [Skins](#skins)
    * [Additional Extensions](#additional-extensions)
    * [Configuration files](#configuration-files)
    * [Performance](#performance)
* [Upgrading](#upgrading)
* [Contributing](#contributing)
* [License](#license)


## Supported Tags

- `latest` [(Dockerfile)](https://github.com/d8sychain/docker-mediawiki/blob/master/Dockerfile)
- `1.33` [Coming Soon]((https://github.com/d8sychain/docker-mediawiki/blob/1.33/Dockerfile))
- `1.34` [Expected late Nov '19]((https://github.com/d8sychain/docker-mediawiki/blob/1.34/Dockerfile))


## Features

- [MediaWiki](https://www.mediawiki.org) 1.33.1
- [Nginx](https://www.nginx.com) 1.16.1
- [PHP-FPM](https://www.php.net/manual/en/book.fpm.php) with [PHP](https://www.mediawiki.org/wiki/Compatibility#PHP) 7.3.8
- [Parsoid](https://www.mediawiki.org/wiki/Parsoid) running on [NodeJS](https://nodejs.org) 10.16.3
- [APCu](https://www.php.net/manual/en/book.apcu.php) PHP caching [*see Mediawiki Perfomance Tuning*](https://www.mediawiki.org/wiki/Manual:Performance_tuning#Object_caching)
- [International Components for Unicode](http://site.icu-project.org/) 64.2 for Unicode normalization
- [Lua](http://www.lua.org) 5.1
- [ImageMagick](https://imagemagick.org/) for thumbnail generation
- [GNU Diffutils](https://www.gnu.org/software/diffutils/)
- Configured with [Short URLs](https://www.mediawiki.org/wiki/Manual:Short_URL)

### Extensions
Extensions that are part of the core Mediawiki are marked.

#### Special Pages
- [ExtensionDistributor](https://www.mediawiki.org/wiki/Extension:ExtensionDistributor)
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
- [PdfHandler](https://www.mediawiki.org/wiki/Extension:PdfHandler)
- [MultimediaViewer](https://www.mediawiki.org/wiki/Extension:MultimediaViewer)
- [UploadWizard](https://www.mediawiki.org/wiki/Extension:UploadWizard)  **core*


## Changelog

See [CHANGELOG.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CHANGELOG.md) for information about the latest changes.


## Known Issues

See [KNOWNISSUES.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/KNOWNISSUES.md) for information about current issues.


## Usage

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

You can also include ```-v /path/to/store/file/uploads:/assets``` to use an alternet storage location for file uploads in your wiki

You should be able to browse your wiki at [http://localhost:9090](http://localhost:9090).


## HTTPS

HTTPS is not supported by the container itself. Its recommended to use a nginx reverse proxy container for HTTPS setups. 

Recommend using Linuxserver.io Let's Encrypt [docker](https://hub.docker.com/r/linuxserver/letsencrypt).


## Configuration


### General

* Use the mediawiki installer to generate **LocalSetting.php** and save it to /var/mediawiki/www/mediawiki
* Restart the mediawiki container ```docker restart mediawiki_wiki ```
* Make any customizations in **ExtraLocalSetting.php** *will be added after **LocalSetting.php** is saved*

From here on ```/config``` and ```/assets``` will refer to the paths that you mapped to these volumes.


### Uploads

To enable file uploads set the environment variable `MEDIAWIKI_ENABLE_UPLOADS` to 1.



### E-Mail

Not setup. *Plan to include in a future build*


### Logo

You can setup your own logo by placing an image named **wiki.png** in ```/config/www/mediawiki/resources/assets/wiki.png``` or by placing a file within ```/config/www/mediawiki``` or in ```/assets``` (if using the optional docker volume for storing uploads) and changing [\$wgLogo](https://www.mediawiki.org/wiki/Manual:$wgLogo) in **LocalSetting.php** to this file


### Favicon

You can setup your own favicon by placing an image  **favicon.ico** in ```/config/www/mediawiki/favicon.ico``` or by placing a file within ```/config/www/mediawiki``` or in ```/assets``` (if using the optional docker volume for storing uploads) and changing [\$wgFavicon](https://www.mediawiki.org/wiki/Manual:$wgLogo) in **ExtraLocalSetting.php** to this file


### Skins

The default skins are packaged with mediawiki:

* monobook
* timeless
* vector

You can add more [skins](https://www.mediawiki.org/wiki/Manual:Skins) by downloading and adding them to ```/confing/www/mediawiki/skins``` and enable as per the skin's installation instructions. Add additional configurations to ```/config/www/mediawiki/ExtraLocalSettings.php```


### Additional Extensions

You can add more [extensions](https://www.mediawiki.org/wiki/Manual:Skins) by downloading and adding them to ```/confing/www/mediawiki/extensions``` and enable as per the skin's installation instructions. Add additional configurations to ```/config/www/mediawiki/ExtraLocalSettings.php```


### Configuration files

Beside the docker like configuration with environment variables you still can use your own full `LocalSettings.php` file.

- NGINX ```/config/nginx/wiki-nginx.conf```
- PHP-FPM ```/config/php/php-fmp.conf```
- PHP ```/config/php/php.ini```
- Parsoid ```/config/parsoid/config.yaml```
- Mediawiki ```/config/www/mediawiki/LocalSettings.php```
- Mediawiki ```/config/www/mediawiki/ExtraLocalSettings.php```

### Performance

The container has some performance related configuration options. If you have more advanced needs you can override the configurations by editing configuration files. If you accidently break one of the configuration files, just delete it and restart the container and it will automatically be replaced with the default.

- NGINX ```/config/nginx/wiki-nginx.conf```
    - line 3 `worker_processes 4` 
- PHP-FPM ```/config/php/php-fmp.conf```
    - line 23 `pm = dynamic`
    - line 24 `pm.max_children = 75`
    - line 25 `pm.start_servers = 1`
    - line 26 `pm.min_spare_servers = 1`
    - line 27 `pm.max_spare_servers = 20`
    - line 28 `pm.max_requests = 500`
- Parsoid ```/config/parsoid/config.yaml```
    - line 2 `num_workers: 4`

## Upgrading

If using `latest`, it will have the newest packages installed. See ```/config/log/package.list``` for a list of installed packages and thier versions. As mediawiki continues to develope newer versions of the docker image will be released. A newer docker image may contain a newer version of mediawiki and the image will automatically backup mediawiki, upgrade it and the database, if `UPGRADE_MEDIAWIKI = enable`. The default is set to disable. It is highly recommended that you **backup your database** before enabling this.



## Contributing

See [CONTRIBUTING.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CONTRIBUTING.md) for information on how to contribute to the project.

See [CONTRIBUTORS.md](https://github.com/d8sychain/docker-mediawiki/blob/master/docs/CONTRIBUTORS.md) for the list of contributors.


## License

This project is licensed under the GPLv3.
