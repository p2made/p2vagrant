<?php
$conn = mysqli_connect("localhost", "user", "password", "db");

if (!$conn) {
	die("Error: " . mysqli_connect_error());
}

echo "Connected!";
