<?php

$wgHooks['MakeGlobalVariablesScript'][] = 'OrainHooks::onMakeGlobalVariablesScript';
$wgHooks['ParserFirstCallInit'][]       = 'OrainHooks::ifUserCanDebug';
$wgHooks['SkinAfterBottomScripts'][]    = 'OrainHooks::piwikScript';

class OrainHooks {

	/**
	 * This creates a new variable (wgPoweredByHHVM) which can be used to decide whether
	 * HHVM is running. Nice for scripts.
	 *
	 * From WikimediaEvents (https://www.mediawiki.org/wiki/Extension:WikimediaEvents)
	 */
	static function onMakeGlobalVariablesScript( &$vars, OutputPage $out ) {
		if ( defined( 'HHVM_VERSION' ) ) {
			$vars['wgPoweredByHHVM'] = true;
		}
	}

	/**
	 * This allows users that are allow to 'debug' to have extra debugging information
	 */
	static function ifUserCanDebug() {
		global $wgUser, $wgShowExceptionDetails, $wgDebugToolbar, $wgDevelopmentWarnings, $wgShowSQLErrors, $wgShowDBErrorBacktrace;
		if ( $wgUser->isAllowed( 'debug' ) ) {
			//error_reporting( -1 ); // phpredis introduces a *lot* of array issues due to live hack within MediaWiki
			error_reporting(E_ALL & ~E_NOTICE & ~E_STRICT); //Here, try this.  Should limit the displayed errors to only the important ones.
			ini_set( 'display_errors', 1 );
			$wgShowExceptionDetails = true;
			$wgDebugToolbar = true;
			$wgDevelopmentWarnings = true;
			$wgShowSQLErrors = true;
			$wgShowDBErrorBacktrace = true;
		}
	}

	static function piwikScript( $skin, &$text = '' ) {
		global $wmgPiwikSiteID, $wgUser;
		if ( !$wmgPiwikSiteID ) {
			$wmgPiwikSiteID = 1;
		}
		$id = strval( $wmgPiwikSiteID );
		$title = $skin->getRelevantTitle();
		$jstitle = Xml::encodeJsVar( $title->getPrefixedText() );
		$urltitle = $title->getPrefixedURL();
		$userType = $wgUser->isLoggedIn() ? "User" : "Anonymous";
		$text .= <<<SCRIPT
<!-- Piwik -->
<script type="text/javascript">
	var _paq = _paq || [];
	_paq.push(["trackPageView"]);
	_paq.push(["enableLinkTracking"]);

	(function() {
		var u = "//piwik.orain.org/";
		_paq.push(["setTrackerUrl", u+"piwik.php"]);
		_paq.push(['setDocumentTitle', {$jstitle}]);
		_paq.push(["setSiteId", "{$id}"]);
		_paq.push(["setCustomVariable", 1, "userType", "{$userType}", "visit"]);
		var d=document, g=d.createElement("script"), s=d.getElementsByTagName("script")[0]; g.type="text/javascript";
		g.defer=true; g.async=true; g.src=u+"piwik.js"; s.parentNode.insertBefore(g,s);
	})();
</script>
<!-- End Piwik Code -->
<!-- Piwik Image Tracker -->
<noscript>
<img src="//piwik.orain.org/piwik.php?idsite={$id}&amp;rec=1&amp;action_name={$urltitle}" style="border:0" alt="" />
</noscript>
<!-- End Piwik -->
SCRIPT;
		return true;
	}

}
