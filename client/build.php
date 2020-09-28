<?php
require 'class.obfuscator.php'; 

build('mars.php');
build('inc/os.php');
build('inc/database.php');
build('inc/omni_commands.php');
build('inc/nbu_commands.php');

function build($filename){
	echo $filename;
	file_put_contents('.build/' . $filename, SmartObfuscator::obfuscate(file_get_contents($filename)));
	echo PHP_EOL;
}