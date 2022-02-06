# Panzer Dragoon Legacy CMS

A custom content management system for
[panzerdragoonlegacy.com](http://www.panzerdragoonlegacy.com). Code is provided
here for demonstration purposes.

## Quick Reference

To stop the application in production, run:
`cd /var/cms && sudo docker-compose -f docker-compose.prod.yml down`

To start the application in production, run:
`cd /var/cms && sudo docker-compose -f docker-compose.prod.yml up -d`

To start and rebuild the application in production, run:
`cd /var/cms && sudo docker-compose -f docker-compose.prod.yml up -d --build`
This will re-run certbot and renew the SSL certificate if it has expired.

## Setup Guides

For instructions on setting up a development environment for the CMS, see
[DEVELOPMENT.md](DEVELOPMENT.md).

To provision a VPS for the CMS's deployment,
see [PRODUCTION.md](PRODUCTION.md).

Both Development and Production environments are set up using Docker Compose,
along with a Cron job for renewing the Let's Encrypt SSL certificate in
production.

There are a couple of Docker volumes which store the website's data called
`cms_database_data` (Postgres database) and `cms_public_data` (Paperclip file
attachments). Ensure that the contents of these volumes are included in every
backup.

## Copyright

Source _code_ files in this repository are © 2021 Chris Alley and are freely
available under the terms of the MIT license.

However, most of the image assets and the Panzer Dragoon and Crimson Dragon
trademarks are the property of SEGA and/or Microsoft and are provided for
demonstration purposes only.
