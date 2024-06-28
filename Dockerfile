FROM ubuntu
RUN apt update
Run apt install apache2 -y
ENTRYPOINT apachectl -D FOREGROUND
COPY . /var/www/html
