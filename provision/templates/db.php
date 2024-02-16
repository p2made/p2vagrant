<?php
/*
 * Generated: {{TODAYS_DATE}}
 */
$host       = "{{VM_HOSTNAME}}";
$username   = "{{DB_USERNAME}}";
$password   = "{{DB_PASSWORD}}";
$database   = "{{DB_NAME}}";

$conn = mysqli_connect($host, $username, $password, $database);

if (!$conn) {
    die("Error: " . mysqli_connect_error());
}

echo "Connected!";
