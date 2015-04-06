#!/bin/bash
set -xe

NAME="webvirtmgr"

case "$1" in

  deploy)
    mkdir -p /data
    #touch /data/webvirtmgr.sqlite3
    chown -R www-data:www-data /data
    mv docker/local_settings.py webvirtmgr/local/
    cd /usr/share/nginx/html/ && ./manage.py syncdb --settings=webvirtmgr.local.local_settings
    cd /usr/share/nginx/html/ && ./manage.py collectstatic --noinput
  ;;

  add_superuser)
    cd /usr/share/nginx/html/ && ./manage.py createsuperuser --settings=webvirtmgr.local.local_settings
  ;;

  serve)
    /usr/bin/supervisord -c /etc/supervisor/conf.d/webvirtmgr.conf -n
  ;;

esac

