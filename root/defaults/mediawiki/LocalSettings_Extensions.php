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

## VisualEditor https://www.mediawiki.org/wiki/Extension:VisualEditor
##wfLoadExtension('VisualEditor');
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

## UserMerge https://www.mediawiki.org/wiki/Extension:UserMerge
#wfLoadExtension('UserMerge');
// By default nobody can use this function, enable for bureaucrat and sysop
$wgGroupPermissions['bureaucrat']['usermerge'] = true;
$wgGroupPermissions['sysop']['usermerge'] = true;
// Default is array( 'sysop' )
$wgUserMergeProtectedGroups = array( 'sysop' );

## SyntaxHighlight_GeSHi https://www.mediawiki.org/wiki/Extension:SyntaxHighlight
#wfLoadExtension( 'SyntaxHighlight_GeSHi' );

## Scribunto https://www.mediawiki.org/wiki/Extension:Scribunto
#wfLoadExtension( 'Scribunto' );
$wgScribuntoDefaultEngine = 'luastandalone';

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

