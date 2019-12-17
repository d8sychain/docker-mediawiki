<?php
// @see https://www.mediawiki.org/wiki/Manual:Configuration_settings
# Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) {
    exit;
}
##########################################################################
##	Configuration settings											    ##
##	See https://www.mediawiki.org/wiki/Manual:Configuration_setting 	##
##  for an index of all supported configuration settings. 				##
##########################################################################


### Extension Configuration Settings ###
// Each extension includes the wfLoadExtension for it.
// If checked to enable the extension during the MediaWiki setup wizard,
// then you do NOT need to uncommit it here.


## ConfirmEdit https://www.mediawiki.org/wiki/Extension:ConfirmEdit
	#wfLoadExtension( 'ConfirmEdit' );
	// There are numerous different CAPTCHA types included with ConfirmEdit. See documentation
	/* Example:
	$wgCaptchaClass = 'SimpleCaptcha';
	$wgCaptchaTriggers['edit']          = true;
	$wgCaptchaTriggers['create']        = true;
	$wgCaptchaTriggers['createtalk']    = true;
	$wgCaptchaTriggers['addurl']        = true;
	$wgCaptchaTriggers['createaccount'] = true;
	$wgCaptchaTriggers['badlogin']      = true; */


## Interwiki https://www.mediawiki.org/wiki/Extension:Interwiki
	#wfLoadExtension( 'Interwiki' );
	// To grant sysops permissions to edit interwiki data
	$wgGroupPermissions['sysop']['interwiki'] = true;


## LocalisationUpdate https://www.mediawiki.org/wiki/Extension:LocalisationUpdate
	#wfLoadExtension( 'LocalisationUpdate' );
	//Default repository source to fetch translation. GitHub is set to default repository.
	//This can be changed but is not recommended
	/* $wgLocalisationUpdateRepositories['github'] = array(
	'mediawiki' =>
		'https://raw.github.com/wikimedia/mediawiki/master/%PATH%',
	'extension' =>
		'https://raw.github.com/wikimedia/mediawiki-extensions-%NAME%/master/%PATH%',
	'skin' =>
		'https://raw.github.com/wikimedia/mediawiki-skins-%NAME%/master/%PATH%'
	); */
	//LocalisationUpdate does not update translations automatically.
	//Whenever you want to run an update, run php extensions/LocalisationUpdate/update.php on the command line, or set up a cron job.


## Maintenance https://www.mediawiki.org/wiki/Extension:Maintenance
	#wfLoadExtension( 'Maintenance' );
	// To grant sysops permissions to run maintenance scripts in WebUI
	$wgGroupPermissions['sysop']['maintenance'] = true;


## OATHAuth https://www.mediawiki.org/wiki/Extension:OATHAuth
	#wfLoadExtension( 'OATHAuth' );
	#$wgGroupPermissions['user']['oathauth-enable'] = true;
	

## Scribunto https://www.mediawiki.org/wiki/Extension:Scribunto
	#wfLoadExtension( 'Scribunto' );
	$wgScribuntoDefaultEngine = 'luastandalone';


## SyntaxHighlight_GeSHi https://www.mediawiki.org/wiki/Extension:SyntaxHighlight
	#wfLoadExtension( 'SyntaxHighlight_GeSHi' );


## TemplateData https://www.mediawiki.org/wiki/Extension:TemplateData
	#wfLoadExtension( 'TemplateData' );
	// OPTIONAL: Experimental dialog interface to edit templatedata JSON
	#$wgTemplateDataUseGUI = true;


## TemplateStyles https://www.mediawiki.org/wiki/Extension:TemplateStyles
	#wfLoadExtension( 'TemplateStyles' );
	// OPTIONAL: See https://www.mediawiki.org/wiki/Extension:TemplateStyles#Configuration for more details
	// Default settings listed below
	/* $wgTemplateStylesAllowedUrls[
		"audio" => [
			"<^https://upload\\.wikimedia\\.org/wikipedia/commons/>"
		],
		"image" => [
			"<^https://upload\\.wikimedia\\.org/wikipedia/commons/>"
		],
		"svg" => [
			"<^https://upload\\.wikimedia\\.org/wikipedia/commons/[^?#]*\\.svg(?:[?#]|$)>"
		],
		"font" => [],
		"namespace" => [
			"<.>"
		],
		"css" => []
	]; */
	#$wgTemplateStylesNamespaces[ 10 => true ];
	#$wgTemplateStylesPropertyBlacklist[];
	#$wgTemplateStylesAtRuleBlacklist[];
	#$wgTemplateStylesUseCodeEditor = true;
	#$wgTemplateStylesAutoParseContent = true;
	#$wgTemplateStylesMaxStylesheetSize = 102400;


## TitleBlacklist https://www.mediawiki.org/wiki/Extension:TitleBlacklist
	#wfLoadExtension( 'TitleBlacklist' );
	// The Title blacklist can be gathered from multiple sources outside the local message.
	// For configuring blacklist sources use code as described below:
	#$wgGroupPermissions['sysop']['tboverride'] = false;
	#$wgTitleBlacklistSources = array(
    #array(
    #     'type' => 'localpage',
    #     'src'  => 'MediaWiki:Titleblacklist',
    #),
    #array(
    #     'type' => 'url',
    #     'src'  => 'https://meta.wikimedia.org/w/index.php?title=Title_blacklist&action=raw',
    #),
    #array(
    #     'type' => 'file',
    #     'src'  => '/home/wikipedia/blacklists/titles',
    #),
	#);
	#$wgTitleBlacklistUsernameSources
	#$wgTitleBlacklistLogHits
	#


## UploadWizard https://www.mediawiki.org/wiki/Extension:UploadWizard
	##wfLoadExtension( 'UploadWizard' );
	#$wgApiFrameOptions = 'SAMEORIGIN'; // Needed to make UploadWizard work in IE, see https://phabricator.wikimedia.org/T41877
	// This modifies the sidebar's "Upload file" link - probably in other places as well.
	#$wgExtensionFunctions[] = function() {
	#	$GLOBALS['wgUploadNavigationUrl'] = SpecialPage::getTitleFor( 'UploadWizard' )->getLocalURL();
	#	return true;
	#};
	// Several other options are available through a configuration array.
	$wgUploadWizardConfig = array(
		'tutorial' => array(
			'skip' => true
			), // Skip the tutorial
		'altUploadForm' => 'Special:Upload',
		'alternativeUploadToolsPage' => false, // Disable the link to alternative upload tools (default: points to Commons)
		'feedbackLink' => false, // Disable the link for feedback (default: points to Commons)
		'maxUploads' => 15, // Number of uploads with one form - defaults to 50
		'fileExtensions' => $wgFileExtensions // omitting this may cause errors
	);


## UserMerge https://www.mediawiki.org/wiki/Extension:UserMerge
	#wfLoadExtension('UserMerge');
	// By default nobody can use this function, enable for bureaucrat and sysop
	$wgGroupPermissions['bureaucrat']['usermerge'] = true;
	$wgGroupPermissions['sysop']['usermerge'] = true;
	// Default is array( 'sysop' )
	$wgUserMergeProtectedGroups = array( 'sysop' );


## VisualEditor https://www.mediawiki.org/wiki/Extension:VisualEditor
	#wfLoadExtension('VisualEditor');
	$wgDefaultUserOptions['visualeditor-enable'] = 1;
	$wgVirtualRestConfig['modules']['parsoid'] = array(
		'url' => 'http://localhost:8142',
		'domain' => 'localhost',
		'prefix' => ''
	);
	$wgSessionsInObjectCache = true;
	$wgVirtualRestConfig['modules']['parsoid']['forwardCookies'] = true;
	// OPTIONAL: Enable VisualEditor's experimental code features
	#$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;
	// Parsoid athentication without forwarding cookies. Allows VisualEditor to work in private wikis.
	if ( !isset( $_SERVER['REMOTE_ADDR'] ) OR $_SERVER['REMOTE_ADDR'] == '127.0.0.1' ) {
		$wgGroupPermissions['*']['read'] = true;
		$wgGroupPermissions['*']['edit'] = true;
	};


## WikiEditor https://www.mediawiki.org/wiki/Extension:WikiEditor
	$wgDefaultUserOptions['usebetatoolbar'] = 1; // user option provided by WikiEditor extension

