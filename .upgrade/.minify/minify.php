<?php
require 'class.obfuscator.php'; 

#minify('index.php');
#minify('inc/database.php');
#minify('inc/page.php');
#minify('inc/report.php');

$iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator('.'));
$allFiles = array_filter(iterator_to_array($iterator), function($file) {
    return $file->isFile() && preg_match('/\.php/', $file->getPathname());
});
foreach (array_keys($allFiles) as $filename) minify($filename);

function minify($filename){
	echo $filename;
	file_put_contents(str_replace('.php','.min.php',$filename), SmartObfuscator::obfuscate(file_get_contents($filename)));
	echo PHP_EOL;
}