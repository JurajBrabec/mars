<?php
require 'class.obfuscator.php'; 

if ($argc<2) die('Usage: minify [path]');
echo 'Minifying scripts in "' . $argv[1] . '"' . PHP_EOL;
$iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($argv[1]));
$allFiles = array_filter(iterator_to_array($iterator), function($file) {
    return $file->isFile() && preg_match('/\.php$/', $file->getPathname());
});
foreach (array_keys($allFiles) as $filename) minify($filename);

function minify($filename){
	echo $filename;
	file_put_contents(str_replace('.php','.min.php',$filename), SmartObfuscator::obfuscate(file_get_contents($filename)));
	echo PHP_EOL;
}