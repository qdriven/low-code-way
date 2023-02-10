<?php

$wgLBFactoryConf = array(
	'class' => 'LBFactoryMulti',
	'sectionsByDB' => array(
		'allthetropeswiki' => 'c2',
		'centralauth' => 'c1', // Not covered by default
		'globalblocking' => 'c1', // Not covered by default
	),
	'sectionLoads' => array(
		'DEFAULT' => array( // ALL wikis unless overriden
			'prod12' => 1,
		),
		'c1' => array( // Non-wikis needing to be directed to c1
			'prod12' => 1,
		),
		'c2' => array(
			'prod5' => 1,
		),
	),
	'serverTemplate' => array(
		'dbname' => $wgDBname,
		'user' => $wgDBuser,
		'password' => $wgDBpassword,
		'type' => 'mysql',
	),
	'hostsByName' => array(
		'prod5' => '10.131.158.213',
		'prod12' => '10.131.158.209',
	),
	// Below is required to be here. This also allows us to easily take a cluster out of service for a reason
	'readOnlyBySection' => array(
	//	'DEFAULT' => 'Currently in read-only mode while we upgrade our infrastructure. -John',
	//	'c2' => '',
	),
);
