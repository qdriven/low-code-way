<?php

$wmgLogDir = "/var/log/mediawiki";

$wgDebugLogFile = "$wmgLogDir/$wmgHostname.log";

$wgDBerrorLog = "$wmgLogDir/debuglogs/database.log";
$wgDebugLogGroups = array(
	'404' => "$wmgLogDir/debuglogs/404.log",
	'addshore' => "$wmgLogDir/debuglogs/addshore.log",
	'api' => "$wmgLogDir/debuglogs/api.log",
	'captcha' => "$wmgLogDir/debuglogs/captcha.log",
	'CentralAuth' => "$wmgLogDir/debuglogs/CentralAuth.log",
	'CirrusSearch' => "$wmgLogDir/debuglogs/CirrusSearch.log",
	'CreateWiki' => "$wmgLogDir/debuglogs/CreateWiki.log",
	'collection' => "$wmgLogDir/debuglogs/collection.log",
	'DBPerformance' => "$wmgLogDir/debuglogs/dbperformance.log",
	'exception' => "$wmgLogDir/debuglogs/exception.log",
	'exec' => "$wmgLogDir/debuglogs/exec.log",
	'magic' => "$wmgLogDir/debuglogs/magic.log",
	'Math' => "$wmgLogDir/debuglogs/Math.log",
	'OAuth' => "$wmgLogDir/debuglogs/OAuth.log",
	'redis' => "$wmgLogDir/debuglogs/redis.log",
	'thumbnail' => "$wmgLogDir/debuglogs/thumbnail.log",
	'torblock' => "$wmgLogDir/debuglogs/torblock.log",
);

$wgScribuntoEngineConf['luastandalone']['errorFile'] = "$wmgLogDir/debuglogs/luastandalone.log";
