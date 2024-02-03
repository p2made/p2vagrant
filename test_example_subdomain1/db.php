<?php
$host       = "localhost";
$username   = "fredspotty";
$password   = "Passw0rd";
$database   = "example_db";

$conn = mysqli_connect($host, $username, $password, $database);

if (!$conn) {
    die("Error: " . mysqli_connect_error());
}

echo "Connected!";
