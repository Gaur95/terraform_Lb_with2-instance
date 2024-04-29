#!/bin/bash
apt update
apt install apache2 -y
echo "<h1>hello from inst2<h1>" >/var/www/html/index.html