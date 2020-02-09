FROM debian:jessie-slim

# greet me :)
MAINTAINER Tobias Rös - <roes@amicaldo.de>

# install dependencies
RUN apt-get update && apt-get install -y \
  gnupg1 \
  dirmngr \
  apt-transport-https \
  python3 \
  py-pip 

RUN install speedtest

# remove default content
RUN rm -R /var/www/*

# create directory structure
RUN mkdir -p /etc/nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/global
RUN mkdir -p /var/www/html

# touch required files
RUN touch /var/log/nginx/access.log && touch /var/log/nginx/error.log

# install vhost config
ADD ./config/vhost.conf /etc/nginx/conf.d/default.conf
ADD config/nginxEnv.conf /etc/nginx/modules/nginxEnv.conf

# install webroot files
ADD ./ /var/www/html/

# install bower dependencies
RUN npm install -g yarn && cd /var/www/html/ && yarn install

EXPOSE 80
EXPOSE 443

RUN chown -R nginx:nginx /var/www/html/
RUN chmod +x /var/www/html/config/run.sh
ENTRYPOINT ["/var/www/html/config/run.sh"]
