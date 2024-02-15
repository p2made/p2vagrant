<?php
// Define variables
$generatedDate  = "{{TODAYS_DATE}}";
$vmHostname     = gethostname();        // Gets the hostname of the machine
$pageTitle      = "Shaka Bom!";
$pageBody       = "How cool is this?";
?>
<html>
<head>
	<title><?= $pageTitle ?></title>
</head>
<body>
	<h1><?= $pageTitle ?></h1>
	<p><?= $pageBody ?></p>
	<hr>
	<p>Generated: <?= $generatedDate ?></p>
	<p>Served by: <?= $vmHostname ?></p>
</body>
</html>
