ARG BASEIMAGE_TAG
FROM ghcr.io/linuxserver/baseimage-alpine:${BASEIMAGE_TAG}
# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="d8sychain"
# php package version prefix for this build (e.g. "7", "81", "83") - matches
# the ${PHPV}-<extension> apk package naming Alpine uses for that PHP series.
# Also kept as a runtime ENV since the php-fpm service script needs it to
# invoke the correctly-versioned php-fpm binary (e.g. php-fpm7, php-fpm81).
ARG PHPV
ENV PHPV=${PHPV}
# environment settings
ENV APK_UPGRADE=false
ENV MEDIAWIKI_VERSION_MAJOR=1
ARG MEDIAWIKI_VERSION_MINOR
ENV MEDIAWIKI_VERSION_MINOR=${MEDIAWIKI_VERSION_MINOR}
ARG MEDIAWIKI_VERSION_BUGFIX
ENV MEDIAWIKI_VERSION_BUGFIX=${MEDIAWIKI_VERSION_BUGFIX}
ENV MEDIAWIKI_VERSION=v$MEDIAWIKI_VERSION_MAJOR\_$MEDIAWIKI_VERSION_MINOR\_$MEDIAWIKI_VERSION_BUGFIX
ENV MEDIAWIKI_BRANCH=REL$MEDIAWIKI_VERSION_MAJOR\_$MEDIAWIKI_VERSION_MINOR
ENV MEDIAWIKI_STORAGE_PATH=/defaults/www/mediawiki
ENV MEDIAWIKI_PATH=/config/www/mediawiki
ENV MEDIAWIKI_EXTENSION_PATH=$MEDIAWIKI_PATH/extensions
ENV EXTENSION_MANAGER_PATH=/config/ExtensionManager
ENV UPGRADE_MEDIAWIKI=disable
# copy local files
COPY root/ /
# build image - start
RUN \
	echo "**** install build packages ****" && \
		apk add --no-cache --upgrade --virtual=build-dependencies \
		curl \
		gnupg \
		git \
		tar && \
	echo "**** install runtime packages ****" && \
		apk add --no-cache --upgrade \
		nginx \
		php${PHPV} \
		php${PHPV}-fpm \
		php${PHPV}-xmlreader \
		php${PHPV}-dom \
		php${PHPV}-intl \
		php${PHPV}-ctype \
		php${PHPV}-iconv \
		php${PHPV}-mysqli \
		php${PHPV}-pgsql \
		php${PHPV}-pdo \
		php${PHPV}-pdo_sqlite \
		php${PHPV}-json \
		php${PHPV}-pecl-apcu \
		php${PHPV}-tokenizer \
		php${PHPV}-mbstring \
		php${PHPV}-xml \
		php${PHPV}-fileinfo \
		php${PHPV}-openssl \
		php${PHPV}-sodium \
		php${PHPV}-curl \
		php${PHPV}-calendar \
		php${PHPV}-session \
		composer \
		diffutils \
		ffmpeg \
		imagemagick \
		poppler-utils \
		python3 \
		lua5.1 \
		make && \
	echo "**** make php-fpm unix socket path ****" && \
		mkdir -p /var/run/php-fpm/ && \
		chown abc:abc /var/run/php-fpm/ && \
# mediawiki core - git submodule init pulls in every extension/skin that
# ships bundled with core (this is MediaWiki's own documented git install
# method - see https://www.mediawiki.org/wiki/Download_from_Git). No need to
# separately clone Parsoid (natively bundled in core since 1.35, no external
# Node.js service needed), Scribunto/PageImages/TextExtracts/VisualEditor/
# TemplateData/SyntaxHighlight_GeSHi, or any of the other extensions listed
# as "bundled by default since 1.18" in the README - they're all core
# submodules, this one step gets them all.
	echo "**** download mediawiki ****" && \
		 mkdir -p $MEDIAWIKI_STORAGE_PATH && \
			git clone \
				--branch ${MEDIAWIKI_BRANCH} \
				--single-branch \
				--depth 1 \
				https://gerrit.wikimedia.org/r/mediawiki/core.git \
				$MEDIAWIKI_STORAGE_PATH && \
			cd $MEDIAWIKI_STORAGE_PATH && \
			git clone \
				https://gerrit.wikimedia.org/r/mediawiki/vendor.git && \
			git submodule update --init && \
			rm -rf .git* && \
# mediawiki additional extensions - not core submodules, fetched separately.
# `--branch` resolves transparently to a tag when the live branch has been
# pruned post-EOL (Wikimedia's practice for old releases) - verified for
# each of these against REL1_35/REL1_39/REL1_43 before relying on it here.
	echo "**** download mediawiki extensions ****" && \
	echo "**** download Maintenance extension ****" && \
		mkdir -p $MEDIAWIKI_STORAGE_PATH/extensions/Maintenance && \
		git clone \
			--branch ${MEDIAWIKI_BRANCH} \
			--single-branch \
			--depth 1 \
			https://gerrit.wikimedia.org/r/mediawiki/extensions/Maintenance \
			$MEDIAWIKI_STORAGE_PATH/extensions/Maintenance && \
		rm -rf $MEDIAWIKI_STORAGE_PATH/extensions/Maintenance/.git* && \
	echo "**** download UploadWizard extension ****" && \
		mkdir -p $MEDIAWIKI_STORAGE_PATH/extensions/UploadWizard && \
		git clone \
			--branch ${MEDIAWIKI_BRANCH} \
			--single-branch \
			--depth 1 \
			https://gerrit.wikimedia.org/r/mediawiki/extensions/UploadWizard \
			$MEDIAWIKI_STORAGE_PATH/extensions/UploadWizard && \
		rm -rf $MEDIAWIKI_STORAGE_PATH/extensions/UploadWizard/.git* && \
	echo "**** download UserMerge extension ****" && \
		mkdir -p $MEDIAWIKI_STORAGE_PATH/extensions/UserMerge && \
		git clone \
			--branch ${MEDIAWIKI_BRANCH} \
			--single-branch \
			--depth 1 \
			https://gerrit.wikimedia.org/r/mediawiki/extensions/UserMerge \
			$MEDIAWIKI_STORAGE_PATH/extensions/UserMerge && \
		rm -rf $MEDIAWIKI_STORAGE_PATH/extensions/UserMerge/.git* && \
	echo "**** download TemplateStyles extension ****" && \
		mkdir -p $MEDIAWIKI_STORAGE_PATH/extensions/TemplateStyles && \
			git clone \
			--branch ${MEDIAWIKI_BRANCH} \
			--single-branch \
			--depth 1 \
			https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateStyles \
			$MEDIAWIKI_STORAGE_PATH/extensions/TemplateStyles && \
		rm -rf $MEDIAWIKI_STORAGE_PATH/extensions/TemplateStyles/.git* && \
	echo "**** download TemplateWizard extension ****" && \
		mkdir -p $MEDIAWIKI_STORAGE_PATH/extensions/TemplateWizard && \
			git clone \
			--branch ${MEDIAWIKI_BRANCH} \
			--single-branch \
			--depth 1 \
			https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateWizard \
			$MEDIAWIKI_STORAGE_PATH/extensions/TemplateWizard && \
		rm -rf $MEDIAWIKI_STORAGE_PATH/extensions/TemplateWizard/.git* && \
		chown -R abc:abc $MEDIAWIKI_STORAGE_PATH && \
# cleanup
	echo "**** cleanup ****" && \
		apk del --purge \
			build-dependencies && \
		rm -rf \
			/tmp/*
# build image - end
# ports and volumes
EXPOSE 80
VOLUME /config /assets
