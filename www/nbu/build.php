<?php
require 'class.obfuscator.php'; 

build('php.php');

function build($filename){
	echo $filename;
	file_put_contents('.build/' . $filename, SmartObfuscator::obfuscate(file_get_contents($filename)));
	echo PHP_EOL;
}