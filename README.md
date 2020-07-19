Panzer Dragoon Legacy CMS
=========================

A custom content management system for
[panzerdragoonlegacy.com](http://www.panzerdragoonlegacy.com). Code is provided
here for demonstration purposes.

Documentation
-------------

For instructions on setting up a development environment for the CMS, see
[DEVELOPMENT.md](DEVELOPMENT.md).

To provision a VPS for the site's deployment,
see [PRODUCTION.md](PRODUCTION.md).

Both Development and Production environments are set up using Docker Compose,
along with a Cron job renewing the Let's Encrypt SSL certificate in production.

There are a couple of Docker volumes which store the website's data called
`cms_database_data` (Postgres database) and `cms_public_data` (Paperclip file
attachements). Ensure that the contents of these volumes are included in every
backup.

Copyright
---------

Source *code* files in this repository are © 2020 Chris Alley and are freely
available under the terms of the MIT license.

However, most of the image assets and the Panzer Dragoon and Crimson Dragon
trademarks are the property of SEGA and/or Microsoft and are provided for
demonstration purposes only.
