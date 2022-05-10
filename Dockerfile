FROM lsiobase/nginx:3.14
# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="d8sychain"
# environment settings
ENV APK_UPGRADE=false
ENV NODE_PATH=$PARSOID_HOME
ENV MEDIAWIKI_VERSION_MAJOR=1
ENV MEDIAWIKI_VERSION_MINOR=37
ENV MEDIAWIKI_VERSION_BUGFIX=2
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
		tar && \
	echo "**** install runtime packages ****" && \
		apk add --no-cache --upgrade \
		php7-xmlreader \
		php7-dom \
		php7-intl \
		php7-ctype \
		php7-iconv \
		php7-mysqli \
		php7-pgsql \
		php7-pdo \
		php7-pdo_sqlite \
		php7-json \
		php7-pecl-apcu \
		php7-tokenizer \
		composer \
		diffutils \
		ffmpeg \
		imagemagick \
		poppler-utils \
		python2 \
		python3 \
		lua \
		make && \
	echo "**** make php7-fpm unix socket path ****" && \
		mkdir -p /var/run/php7-fpm/ && \
		chown abc:abc /var/run/php7-fpm/ && \
# mediawiki core, includes bundled extentions
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
# mediawiki additional extensions
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
	echo "**** download WikiSEO extension ****" && \
		mkdir -p $MEDIAWIKI_STORAGE_PATH/extensions/WikiSEO && \
		git clone \
			--branch ${MEDIAWIKI_BRANCH} \
			--single-branch \
			--depth 1 \
			https://gerrit.wikimedia.org/r/mediawiki/extensions/WikiSEO \
			$MEDIAWIKI_STORAGE_PATH/extensions/WikiSEO && \
		rm -rf $MEDIAWIKI_STORAGE_PATH/extensions/WikiSEO/.git* && \
	echo "**** download UploadWizard extension ****" && \
		mkdir -p $MEDIAWIKI_STORAGE_PATH/extensions/UploadWizard && \
		git clone \
			--branch ${MEDIAWIKI_BRANCH} \
			--single-branch \
			--depth 1 \
			https://gerrit.wikimedia.org/r/mediawiki/extensions/UploadWizard \
			$MEDIAWIKI_STORAGE_PATH/extensions/UploadWizard && \
		rm -rf $MEDIAWIKI_STORAGE_PATH/extensions/UploadWizard/.git* && \
	echo "**** download UserMerge extensions ****" && \
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