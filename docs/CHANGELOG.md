CHANGELOG

# Docker MediaWiki
* Note: Changes to configuration files will not override your current files.
	* If you want the newest version of a config file, delete or rename your old file first.
	* Then restart the container and the new config file will be added, then you can merge any customizations that you may have made in your original file.

## 2026-09-22 - 1.35.14 / 1.39.17 / 1.43.9-db3 - Upload/thumbnail permissions, VisualEditor fixes

### Fixed
* `15-config-wiki`'s `chmod -R a=rw` on `$MEDIAWIKI_PATH/images` and `/assets` stripped the execute/traversal bit from every directory (not just files), breaking `FileBackend`/`FSLockManager`'s own directory creation for hashed upload subdirectories and lock files. Since this script runs on every container start, this silently broke file uploads and produced "Error creating thumbnail: File missing" for any file added since the last restart - not a one-time issue, this recurred on every restart. Fixed with `a=rwX` (capital X applies execute only to directories).
* `git submodule update --init` (non-recursive) during the image build leaves VisualEditor's own nested submodule (`lib/ve`, its standalone core editing library, declared in VisualEditor's own `.gitmodules`) as an empty directory. Broke VisualEditor at runtime with a `ResourceLoader` "package file not found" error and no visible error in the browser UI. Fixed with `--recursive`.
* nginx's `/var/lib/nginx/tmp` (FastCGI/proxy/client_body temp buffers) was owned by the `nginx` apk package's own system user at mode 700, but this image's `nginx.conf` runs workers as `abc` - blocking `abc` from even traversing into the directory. Broke `load.php` (and therefore VisualEditor's JS/CSS, since it's loaded via ResourceLoader) with "Permission denied reading upstream". Fixed by chowning it to `abc:abc` at build time.

All three found and fixed against real jsrwiki production data. Note: this release does not change the underlying MediaWiki versions (still 1.35.14 / 1.39.17 / 1.43.9) - it's a bugfix rebuild of the same versions.

## 2026-09-13 - 1.35.14 / 1.39.17 / 1.43.9-db2 - Interactive maintenance menu, Composer extensions, integrated MariaDB, backups

### Added
* Interactive `maintenance` terminal menu (`docker exec -it <container> maintenance`) covering Extension Manager, Backups, Database, and Services - ported from this project's own long-unmerged `edge` branch and adapted onto the modernized codebase (edge was still on the old EOL 1.33.2 base, only its architecture was ported, not its MediaWiki version)
* Composer-based extension support (e.g. [Maps](https://www.mediawiki.org/wiki/Extension:Maps), [Semantic MediaWiki](https://www.semantic-mediawiki.org/)) via a new `~package:version:ExtensionName` bulk-edit operator and a matching interactive menu option - see [Composer-Based Extensions](../README.md#composer-based-extensions)
* Optional integrated MariaDB (`MYSQL_INSTALL_OPTION=true`) for running the database in the same container - opt-in, off by default; a separate database container remains the default and recommended setup
* Backups: on-demand and cron-scheduled, covering MediaWiki files/database/assets/config, with restore - works against a separate database container, an integrated one, or SQLite

### Fixed
* `git` was installed only as a build-time dependency and purged from the final image - `ExtensionManager`'s `git clone`/`git ls-remote` calls need it at runtime, so adding or removing a git-based extension (via the bulk MANAGER file or the new menu) has been silently non-functional on every previously published 1.35/1.39/1.43 image since the prior modernization release. Never caught because jsrwiki (this project's own reference deployment) doesn't use any extensions beyond the bundled defaults.
* Composer's own apk-packaged wrapper script hardcoded whichever bare PHP happened to be bundled in the base image at build time (e.g. PHP 8.4/8.5), completely bypassing this image's actual configured PHP version and its extensions - composer could not resolve any real dependency graph until fixed. This was previously latent since the only existing composer call (TemplateStyles' own `composer install`) never needed any PHP extensions its narrow per-extension composer.json didn't already require.

### Notes for Composer-extension users
* Adding a Composer extension resolves the entire dependency graph (a full `composer update --no-dev -o`, not a scoped update - MediaWiki's git-install method has no root-level lock file to support scoping), so unrelated package versions may shift when you add one.
* **Semantic MediaWiki requires >=6.0 for MediaWiki 1.43** - 5.x releases throw a database error on any real query or page deletion under 1.43's core; this is upstream SMW's own compatibility boundary, not specific to this image.

## 2026-09-12 - 1.35 / 1.39 / 1.43-db1 - Major modernization

* Rebuilt on the current LinuxServer.io Alpine baseimage (s6-overlay v3) instead of the EOL `lsiobase/nginx:3.10`
* Bumping MediaWiki to 1.35.14 / 1.39.17 / 1.43.9 (1.43 is the current LTS) via a staged 1.33 -> 1.35 -> 1.39 -> 1.43 upgrade path, verified against real production data at every hop, not just a fresh install
* Removed the standalone Node.js Parsoid service entirely - Parsoid's PHP port has been natively bundled in MediaWiki core since 1.35, VisualEditor now talks to it directly with no separate service to run or configure
* Simplified extension fetching: Scribunto/PageImages/TextExtracts/VisualEditor/TemplateData/SyntaxHighlight_GeSHi are genuine git submodules of MediaWiki core at every supported version - a single `git submodule update --init` replaces a dozen+ lines of redundant per-extension cloning. Only Maintenance/UploadWizard/UserMerge/TemplateStyles/TemplateWizard still need separate fetching
* Dockerfile: added `git`, `nginx`, and the versioned PHP base package (all previously bundled for free by the old `lsiobase/nginx` base image, none of which exist on the new generic base)
* Dockerfile: symlinked bare `php` to the correctly-configured versioned PHP binary - the new baseimage ships its own bare `/usr/bin/php` (a different, newer release with none of the extensions this image actually installs), which several scripts and composer invoke unqualified
* Added `php-xml`/`fileinfo`/`openssl`/`sodium`/`curl`/`calendar`/`session` to the installed PHP extensions - all required by current MediaWiki but not present in the original 2019 package list
* nginx: added the `SCRIPT_FILENAME` fastcgi_param to the direct `.php$` location block (Alpine's default fastcgi_params omits it, and the original config never set it explicitly either)
* 15-config-wiki: now creates `/config/log/nginx` and `/config/log/php` (previously only present because the old base image pre-created them), and dynamically resolves the actual PHP-FPM socket directory from the live `www2.conf` instead of assuming a fixed path - keeps upgrades from pre-1.35 images working without a config file edit
* 16-upgrade: now checks `update.php`'s exit status before marking an upgrade complete - previously a failed database migration would still get marked as a successful upgrade, silently leaving the wiki running against a half-migrated schema. This was a real, previously-existing defect, not something introduced by this modernization - it just hadn't been triggered by a real `update.php` failure until now
* Fixed missing executable bit on every `cont-init.d` script (644, not 755) - the old base tolerated this, the new one does not
* KNOWNISSUES.md: documented that upgrading from a pre-1.35 image requires deleting both `/config/nginx/nginx.conf` and `/config/php/www2.conf` together (not just one - they must agree on the same socket path)
* README.md: updated Supported Tags and Features to reflect the current 1.35/1.39/1.43 lineup and corrected several extensions incorrectly still listed as "will be bundled in 1.34+"

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
* Cleaned up some whitespace in /root/cont-init.d/

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
