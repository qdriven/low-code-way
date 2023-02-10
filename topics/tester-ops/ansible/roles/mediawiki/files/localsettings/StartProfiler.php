<?php
if ( !mt_rand( 0, 50 ) ) {
	$wgProfiler['class'] = 'Profiler';
} else {
	$wgProfiler['class'] = 'ProfilerStub';
}
