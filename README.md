# Panzer Dragoon Legacy CMS

[![CircleCI Build Status](https://circleci.com/gh/panzerdragoonlegacy/cms.svg?style=shield)](https://circleci.com/gh/panzerdragoonlegacy/cms)

The source code for the website and single purpose content management system of
[panzerdragoonlegacy.com](https://www.panzerdragoonlegacy.com).

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

Source _code_ files in this repository are © 2022 Chris Alley and are freely
available under the terms of the MIT license. However image assets included in
this repository are provided for demonstration purposes only.
