FROM ubuntu:20.04
RUN  apt-get update
RUN  apt-get install nginx -y

RUN mkdir /data
RUN echo "probando Docker" > /var/www/html/index.html

WORKDIR /data

EXPOSE 8080
CMD nginx -g 'daemon off;'
