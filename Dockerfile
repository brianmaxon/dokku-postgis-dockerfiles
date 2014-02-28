# forked from https://github.com/Kloadut/dokku-pg-dockerfiles and https://github.com/helmi03/docker-postgis/commit/51a03d887816375cd219b0a209cb814b836c2cdf

FROM ubuntu:12.04
MAINTAINER	brianmaxon "brian@brianmaxon.com"

# prevent apt from starting postgres right after the installation
RUN	echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install ca-certificates
RUN apt-get -y install wget
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install postgresql-9.3 postgresql-contrib-9.3 postgresql-9.3-postgis-2.1 postgis
RUN apt-get clean

# allow autostart again
RUN	rm /usr/sbin/policy-rc.d


RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.3/main/pg_hba.conf

ADD start_pgsql.sh /start_pgsql.sh
RUN chmod 0755 /start_pgsql.sh

RUN sed -i -e"s/var\/lib/opt/g" /etc/postgresql/9.3/main/postgresql.conf
