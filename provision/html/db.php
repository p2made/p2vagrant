<?php
$conn = mysqli_connect("localhost", "db_user", "db_password", "db");

if (!$conn) {
	die("Error: " . mysqli_connect_error());
}

echo "Connected!";
