<?php
// the $_POST[] array will contain the passed in filename and filedata
// the directory "data" must be writable by the server
$filename = "../data/".$_POST['filename'];
$data = $_POST['filedata'];
// write the file to disk
file_put_contents($filename, $data,FILE_APPEND);
?>
