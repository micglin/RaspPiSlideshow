<?php
  $str = file_get_contents('php://input');
  //echo $filename = $_GET["name"] . "-" . md5(time().uniqid()).".jpg";
  echo $filename = $_GET["name"];
  file_put_contents("/usr/share/nginx/www/share/".$filename,$str);
  // In demo version i delete uplaoded file immideately, Please remove it later
  //unlink("uploads/".$filename);
?>
