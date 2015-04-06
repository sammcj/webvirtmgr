FROM debian:jessie
MAINTAINER Sam McLeod @s_mcleod

VOLUME /data

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y git python-pip python-libvirt python-libxml2 novnc supervisor nginx sed && \
    rm /etc/nginx/sites-enabled/default

ADD . /usr/share/nginx/html/

WORKDIR /usr/share/nginx/html

RUN pip install -r requirements.txt

RUN mkdir -p /etc/nginx/sites-enabled && rm -f /etc/nginx/nginx.conf && \
    mv docker/nginx.conf /etc/nginx/nginx.conf && \
    mv docker/webvirtmgr.conf /etc/nginx/sites-enabled/default && \
    sed -i 's/8000/9000/g' /usr/share/nginx/html/conf/gunicorn.conf.py

RUN mv docker/supervisor.conf /etc/supervisor/conf.d/webvirtmgr.conf && \
    chown www-data.www-data -R .

RUN mv docker/invoke.sh /usr/bin/invoke && chmod +x /usr/bin/invoke

ENTRYPOINT ["/usr/bin/invoke"]

EXPOSE 16514
EXPOSE 8000
