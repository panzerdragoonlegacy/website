#!/bin/bash

COMPOSE="/usr/local/bin/docker-compose --no-ansi"
DOCKER="/usr/bin/docker"

cd /var/cms/
$COMPOSE -f docker-compose.prod.yml run certbot renew
$COMPOSE kill -s SIGHUP webserver
$DOCKER system prune -af
