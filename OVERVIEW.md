# Site Overview

An overview of how the Panzer Dragoon Legacy website and related services are
set up.

## Domain

The domain panzerdragoonlegacy.com is hosted by Namecheap.

<http://www.namecheap.com>

Each domain administrator should have their own Namecheap account linked to
their email address. These accounts have full control over the domain.

## Hosting

The main site and forum for Panzer Dragoon Legacy are hosted on Digital Ocean.
These virtual servers can be configured via the Digital Ocean control panel.

<https://www.digitalocean.com>

Each administrator should have their own Digital Ocean account linked to their
email address. These accounts have full control over the virtual servers, but
do not have access to billing details.

### Virtual Servers (Droplets)

The site and forums are hosted on two virtual servers:

* 188.166.22.249 damon (hosts the main site)
* 188.166.107.168 paet (hosts the forum)

Administrators can access these servers using SSH key based authentication only.
There is no FTP access enabled. The root password for each server can be reset
via the Digital Ocean control panel.

### Backups

Both droplets are automatically backed up regularly. These backups can be
accessed via the Digital Ocean control panel.

## Applications

The site is made up of two applications, a custom Rails application for the
main site, and a Discourse forum.

### The Main Site

#### Updating the Site's Content

##### Using the Web UI

All content on the main site can and should be added, edited, or deleted via
the Rails application's web-based graphical user interface. Administrators and
other contributors can log in via this link:

<http://www.panzerdragoonlegacy.com/log-in>

##### Using the Command Line

Occasionally you may need to update the site's content without the constraints
of the web user interface. However, be warned that these constraints have been
put in place for a reason! If you must use the command line, it is better to
use Rails console rather than updating tables in PostgreSQL directly. This will
ensure that all changes to data will go through the Rails models, performing
validations and updating any file attachments and polymorphic associations that
would not otherwise be updated by editing the data directly through Postgres.
Only update the site's content via the database or files directly if you know
what you're doing!

##### Uploading Videos Larger Than the Soft Limit

The maximum upload size for videos is 200 megabytes due to memory limitations
on damon. However, you may want to upload videos larger than 200 megabytes. To
do this, follow these instructions:

1. Click on the [New Video](http://www.panzerdragoonlegacy.com/videos/new) link
to start creating a new video record.

2. In the name field, enter the name that you want to use for the video. Also,
add an appropriate description, category, and (optionally) a YouTube video ID.

3. Choose a placeholder video file from your computer for the MP4 Video with the
file extension .mp4. The file will need to be smaller than 200 megabytes.

4. Submit the New Video form.

5. Log into damon using SSH and go to the following location:
`/home/panzerdragoonlegacy/panzerdragoonlegacy/shared/public/system/mp4_videos`

6. In the `mp4_videos` directory there will be a number of subdirectories. The
placeholder video file should be located in the directory with the highest
number as its name (the ID of the most recent video record created), in a
subdirectory called `original`.

7. Check that the .mp4 file name matches the url of the video record, then
replace the placeholder file with the real video file. The file names must be
identical.

8. Go to the video's page and check that the correct video is playing.

#### Updating the Site's Software

To update the Rails app with new code changes, commit any changes to the master
branch and push them to GitHub. Then use Capistrano to push the changes to
damon. Full details of how to deploy the app can be found in DEVELOPMENT.md.

##### Source Code

The source code for Panzer Dragoon Legacy is stored on GitHub:

<https://github.com/chrisalley/panzer-dragoon-legacy>

The code on master branch should reflect the live version of the site.

##### Database

The main site's data is stored in a PostgreSQL database on damon called
`panzerdragoonlegacy` which can be accessed via psql. It is best to manipulate
any data via the web interface or Rails console, however.

##### Media Files

Pictures, videos, zip files, etc are stored in following folder on damon:

`/home/panzerdragoonlegacy/panzerdragoonlegacy/shared/public/system`

These files are linked to records in the database by the ID numbers of their
containing folders.

##### Creating an Adhoc Backup

If you need to create an adhoc backup of the site, remember to back up all
three parts of the site: the source code, the database, and the media files.
The app may not restore correctly if the backups are taken at different times
and any of the three parts are out of sync.

### The Forum

The forum is powered by the Discourse forum software.

<http://github.com/discourse/discourse>

#### Updating the Forum Software

Discourse will automatically detect new updates when they are available.
Updates can be applied by administrators via the Discourse administration panel:

<http://discuss.panzerdragoonlegacy.com/admin>

This will perform updates via the Discourse Docker container. If need be, you
may need to rebuild or configure to the Docker container directly using the
command line, however such cases are rare. See the Discourse documentation for
more details.

#### Creating an Adhoc Backup

If you need to create an adhoc backup of the forum you can do so via the
Discourse administration panel.

## Social Media

Panzer Dragoon Legacy has a presence on a number of social media websites. This
section outlines how to access these accounts.

### Facebook

The Facebook page can be updated via the administrator's personal Facebook
account.

### Twitter

The Twitter page is linked to the email address
`panzerdragoonlegacy@gmail.com`.

### YouTube

The YouTube account is owned by the Google account
`panzerdragoonlegacy@gmail.com` for which a password reset email can be sent to
`support@panzerdragoonlegacy.com` or Chris' personal email. The YouTube channel
can be managed via the administrator's personal Google account.

### Steam

The Steam group can be updated via the administrator's personal Steam account.

### Discord

The Discord server owner is linked to the email address
`panzerdragoonlegacy@gmail.com`.

## Additional Accounts

Both the main site and forum use Mailgun to send email.

<http://www.mailgun.com>

The account for this service is linked to the email address
`support@panzerdragoonlegacy.com`. As with Twitter, this email address can be
reconfigured to redirect to another email address using the Namecheap control
panel.
