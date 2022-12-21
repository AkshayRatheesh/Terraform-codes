#!/bin/bash


sudo apt update -y
sudo apt install nginx -y
sudo apt install mysql-server -y
#sudo mysql_secure_installation -y

sudo apt install php7.4-fpm php-mysql -y

sudo mkdir /var/www/test.akshayyy.ml

sudo chown -R $USER:$USER /var/www/test.akshayyy.ml

sudo touch /etc/nginx/sites-available/test.akshayyy.ml

sudo echo 'server {
    listen 80;
    server_name test.akshayyy.ml www.test.akshayyy.ml;
    root /var/www/test.akshayyy.ml;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}' > /etc/nginx/sites-available/test.akshayyy.ml



sudo ln -s /etc/nginx/sites-available/test.akshayyy.ml /etc/nginx/sites-enabled/

sudo unlink /etc/nginx/sites-enabled/default

#sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

sudo nginx -t

sudo systemctl reload nginx


sudo touch /var/www/test.akshayyy.ml/index.html


sudo echo '<html>
  <head>
    <title>test.akshayyy.ml website</title>
  </head>
  <body>
    <h1>Hello World!</h1>

    <p>This is the landing page of <strong>test.akshayyy.ml</strong>.</p>
  </body>
</html>' > /var/www/test.akshayyy.ml/index.html


sudo touch /var/www/test.akshayyy.ml/info.php


sudo echo '<?php
phpinfo();' > /var/www/test.akshayyy.ml/info.php


sudo apt install certbot python3-certbot-nginx -y

certbot run -n --nginx --agree-tos -d test.akshayyy.ml,www.test.akshayyy.ml  -m  akshay@riafy.me  --redirect
