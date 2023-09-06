<?php
$conn = mysqli_connect("localhost", "fredspotty", "Pa$$w0rdTw0", "example_db");

if (!$conn) {
	die("Error: " . mysqli_connect_error());
}

echo "Connected!";
