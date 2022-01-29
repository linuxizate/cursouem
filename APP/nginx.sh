#!/bin/bash
if [[ "${UID}" -ne 0 ]]
then
	echo "Necesitas ser Root"
	exit 1
fi

echo "INSTALANDO NGINX"
apt-get update &>/dev/null && apt-get install nginx -y &>/dev/null 
systemctl enable nginx && echo "NGINX INSTALADO"

echo "CONFIGURANDO NGINX COMO BALANCEADOR" 
echo -e "upstream nodejs  {
  server 10.9.8.20:3000 max_fails=3;
  server 10.9.8.30:3000 max_fails=3;
}

server {
  listen 80;
  server_name  www.myapp.com;
  location / {
    proxy_pass  http://nodejs;
    proxy_set_header  X-Real-IP  \$remote_addr;
    proxy_set_header  Host  \$http_host;

  }
}"> /etc/nginx/sites-available/myapp

echo -e "upstream decepticons  {
  server 10.9.8.21 max_fails=3;
  server 10.9.8.22 max_fails=3;
}

server {
  listen 80;
  server_name  www.decepticons.com;
  location / {
    proxy_pass  http://decepticons;
    proxy_set_header  X-Real-IP  \$remote_addr;
    proxy_set_header  Host  \$http_host;

  }
}
"> /etc/nginx/sites-available/decepticons

echo -e "upstream autobots  {
  server 10.9.8.21 max_fails=3;
  server 10.9.8.22 max_fails=3;
}

server {
  listen 80;
  server_name  www.autobots.com;
  location / {
    proxy_pass  http://autobots;
    proxy_set_header  X-Real-IP  \$remote_addr;
    proxy_set_header  Host  \$http_host;

  }
}
"> /etc/nginx/sites-available/autobots



ln -s /etc/nginx/sites-available/autobots /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/decepticons /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/

systemctl restart nginx && echo "NGINX CONFIGURADO COMO LOAD BALANCER"




