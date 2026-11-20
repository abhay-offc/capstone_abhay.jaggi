#!/bin/bash

exec > >(tee /var/log/user-data.log)
exec 2>&1

set -eux

sleep 60

for i in {1..10}; do
    apt-get update && break
    echo "apt update failed. Retrying..."
    sleep 30
done

for i in {1..10}; do
    apt-get install -y nginx && break
    echo "nginx install failed. Retrying..."
    sleep 30
done

mkdir -p /var/www/html

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html>
<head>
    <title>Terraform Website</title>
</head>
<body>
    <h1>Hello from Terraform!</h1>
    <p>Nginx installed successfully.</p>
</body>
</html>
HTML

systemctl enable nginx
systemctl restart nginx

systemctl status nginx
