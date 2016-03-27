# Production Configuration

Step-by-step instructions for setting up the site on a VPS.

## Create Linux User Accounts for the Admin and Webapp Users

1. Add the user account with a suitable password:

  `sudo adduser chrisalley`

2. If appropriate, give the user sudo access (only if needed). The webapp user
   `panzerdragoonlegacy` should not be added to this group:

  `sudo adduser chrisalley sudo`

3. Switch to the new user:

  `sudo su chrisalley`

4. Create new public and private SSH keys for the user:

  `ssh-keygen -t rsa`

5. Create other files for SSH:

  `touch ~/.ssh/authorized_keys`

  `touch ~/.ssh/known_hosts`

  `touch ~/.ssh/config`

6. On chrisalley's local machine, copy his SSH public key:

  `cat ~/.ssh/id_rsa.pub`

7. Back on the server, open authorized_keys and paste in chrisalley's public
   key:

  `vim ~/.ssh/authorized_keys`

8. If not done already, set the server to only allow key-based authentication.
   Open `sshd_config`:

  `sudo vim /etc/ssh/sshd_config`

8. Add the following line and save the file:

  `PasswordAuthentication no`

9. Restart the SSH service to apply the change:

  `sudo restart ssh`

12. Test that key based authentication works for the new user!

13. Repeat the steps any other admin users and for the web app user
    `panzerdragoonlegacy` which we will use to deploy the app. For the web app
    user, skip step (2) where we added the user to the sudoers group.

## Install rbenv

1. Ensure that apt-get is up to date:

   `sudo apt-get update`

2. Switch to the `panzerdragoonlegacy` user:

   `sudo su panzerdragoonlegacy`

2. Install rbenv and ruby-build for the `panzerdragoonlegacy` user:

   ```
   git clone https://github.com/rbenv/rbenv.git ~/.rbenv
   cd ~/.rbenv && src/configure && make -C src
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
   echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

   git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
   echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
   ```

3. Restart the terminal for the changes to come into effect:

4. Install the ruby version in the Rails app's `.ruby_version` file:

    `rbenv install -v 2.3.0`

5. Set this ruby version to be the global ruby:

    `rbenv global 2.3.0`

6. Prevent rubygems from creating local documentation for gems:

    `echo "gem: --no-document" > ~/.gemrc`

7. Install Bundler:

    `gem install bundler`

8. Install Rails:

    `gem install rails`

9. Rehash rbenv to install shims for Rails:

    `rbenv rehash`

## Install Other Rails Dependencies

1. Install nodejs (for the asset pipeline):

   `sudo apt-get install nodejs`

2. Install imagemagick (for processing image attachments):

   `sudo apt-get install imagemagick`

## Set Up PostgreSQL

1. Install PostgreSQL:

  `sudo apt-get install postgresql postgresql-contrib libpq-dev`

2. Log in to PostgreSQL:

  `sudo -u postgres psql`

3. Create a user for the webapp:

   `CREATE USER panzerdragoonlegacy WITH ENCRYPTED PASSWORD 'PASSWORDHERE';`

4. Create a database for the webapp:

   `CREATE DATABASE panzerdragoonlegacy;`

5. Give the user you created full access to the database:

   `GRANT ALL PRIVILEGES ON DATABASE panzerdragoonlegacy TO panzerdragoonlegacy;`

6. Set the owner of the database to the user:

   `ALTER DATABASE panzerdragoonlegacy OWNER TO panzerdragoonlegacy;`

7. Quit postgres:

   `\q`

## Install Capistrano

1. Locally, install Capistrano and some addons in your Rails app by adding
   the following to `Gemfile`:

   ```ruby
   group :development do
     gem 'capistrano', '3.4.0'
     gem 'capistrano-bundler', '~> 1.1.4'
     gem 'capistrano-rails', '~> 1.1.6'
     gem 'capistrano-rbenv', '~> 2.0.4'
   end
   ```

2. Run the bundle command:

   `bundle`

3. Generate Capistrano files:

   `cap install`

4. Uncomment the following lines in `Capfile`:

   `require 'capistrano/rbenv'`

   `require 'capistrano/bundler'`

   `require 'capistrano/rails/assets'`

   `require 'capistrano/rails/migrations'`

5. Modify `config/deploy.rb` to include these settings:

   ```ruby
   set :application, 'panzerdragoonlegacy'
   set :repo_url, 'git@github.com:chrisalley/panzer-dragoon-legacy.git'

   set :deploy_to, '/home/panzerdragoonlegacy/panzerdragoonlegacy'

   set :pty, true

   set :rbenv_type, :user # or :system, depends on your rbenv setup
   set :rbenv_ruby, File.read('.ruby-version').strip

   set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=" +
     "#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
   set :rbenv_map_bins, %w{rake gem bundle ruby rails}
   set :rbenv_roles, :all # default value

   set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids',
     'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system',
     'public/uploads')
   set :linked_files, fetch(:linked_files, []).push('config/database.yml',
     'config/secrets.yml')
   ```

5. Add the following to `config/deploy/production.rb`:

   ```ruby
   server '188.166.22.249', user: 'panzerdragoonlegacy', roles: %w{app web db}
   ```

6. Deploy the app and ensure that there are no errors:

   `cap production deploy`

## Configure database.yml and secrets.yml

1. On the server, connect as the deploy user.

   `sudo su panzerdragoonlegacy`

2. Create a directory for the config files.

   `mkdir ~/panzerdragoonlegacy/shared/config`

3. Create a database.yml file.

   `vim ~/panzerdragoonlegacy/shared/config/database.yml`

4. Paste in the following configuration, updating the `database`, `username`,
   and `password` fields:

   ```yaml
   production:
     adapter: postgresql
     encoding: unicode
     host: localhost
     pool: 5
     timeout: 5000
     database: panzerdragoonlegacy
     username: panzerdragoonlegacy
     password: PASSWORDHERE
   ```

5. In your local Rails app's directory, create a secret key base and copy it to
   the clipboard.

   `rake secret`

6. Create a `secrets.yml` file.

   `vim ~/panzerdragoonlegacy/shared/config/secrets.yml`

7. Type in the following configuration, pasting in the secret key base that we
   generated earlier with `rake secret` and filling in the Twitter and Mailgun
   API details:

   ```yaml
   production:
     <<: *default
     secret_key_base:
     twitter:
      consumer_key:
      consumer_secret:
      oauth_token:
      oauth_token_secret:
    smtp_settings:
      address:
      port:
      user_name:
      password:
   ```

## Install Unicorn in the Rails App

1. Locally, install the Unicorn gem in your Rails app by adding it to `Gemfile`:

    `gem 'unicorn', '~> 5.0.1'`

2. Create a config file for unicorn:

    `vim config/unicorn.rb`

3. Paste in the following configuration:

    ```ruby
    # Set path to application
    app_dir = File.expand_path("../..", __FILE__)
    working_directory app_dir

    # Set unicorn options
    worker_processes 2
    preload_app true
    timeout 30

    # Set up socket location
    listen "#{app_dir}/tmp/sockets/unicorn.sock", backlog: 64

    # Logging
    stderr_path "#{app_dir}/log/unicorn.stderr.log"
    stdout_path "#{app_dir}/log/unicorn.stdout.log"

    # Set master PID location
    pid "#{app_dir}/tmp/pids/unicorn.pid"
    ```

5. Commit the changes:

    `git add -A`

    `git commit -am "Add unicorn to the project"`

## Configure Unicorn on the Server

4. Create the directories referred to in the configuration file:

   `mkdir -p ~/panzerdragoonlegacy/shared/pids ~/panzerdragoonlegacy/shared/sockets ~/panzerdragoonlegacy/shared/log`

1. Create an init script to start and stop Unicorn:

   `sudo vim /etc/init.d/unicorn_panzerdragoonlegacy`

2. Add the following to `unicorn_panzerdragoonlegacy`. Be sure to substitute
   USER and APP_NAME under app settings:

   ```bash
   #!/bin/sh

   ### BEGIN INIT INFO
   # Provides:          unicorn
   # Required-Start:    $all
   # Required-Stop:     $all
   # Default-Start:     2 3 4 5
   # Default-Stop:      0 1 6
   # Short-Description: starts the unicorn app server
   # Description:       starts unicorn using start-stop-daemon
   ### END INIT INFO

   set -e

   USAGE="Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"

   # app settings
   USER="panzerdragoonlegacy"
   APP_NAME="panzerdragoonlegacy"
   APP_ROOT="/home/$USER/$APP_NAME/current"
   ENV="production"

   # environment settings
   PATH="/home/$USER/.rbenv/shims:/home/$USER/.rbenv/bin:$PATH"
   CMD="cd $APP_ROOT && bundle exec unicorn -c config/unicorn.rb -E $ENV -D"
   PID="$APP_ROOT/tmp/pids/unicorn.pid"
   OLD_PID="$PID.oldbin"

   # make sure the app exists
   cd $APP_ROOT || exit 1

   sig () {
     test -s "$PID" && kill -$1 `cat $PID`
   }

   oldsig () {
     test -s $OLD_PID && kill -$1 `cat $OLD_PID`
   }

   case $1 in
     start)
       sig 0 && echo >&2 "Already running" && exit 0
       echo "Starting $APP_NAME"
       su - $USER -c "$CMD"
       ;;
     stop)
       echo "Stopping $APP_NAME"
       sig QUIT && exit 0
       echo >&2 "Not running"
       ;;
     force-stop)
       echo "Force stopping $APP_NAME"
       sig TERM && exit 0
       echo >&2 "Not running"
       ;;
     restart|reload|upgrade)
       sig USR2 && echo "reloaded $APP_NAME" && exit 0
       echo >&2 "Couldn't reload, starting '$CMD' instead"
       $CMD
       ;;
     rotate)
       sig USR1 && echo rotated logs OK && exit 0
       echo >&2 "Couldn't rotate logs" && exit 1
       ;;
     *)
       echo >&2 $USAGE
       exit 1
       ;;
   esac
   ```
3. Update the script's permissions:

   `sudo chmod 755 /etc/init.d/unicorn_panzerdragoonlegacy`

4. Enable Unicorn to start on boot:

   `sudo update-rc.d unicorn_panzerdragoonlegacy defaults`

5. We can now start the Rails app with:

   `sudo service unicorn_panzerdragoonlegacy start`

## Install NGINX

1. Install NGINX using apt-get:

   `sudo apt-get install nginx`

2. Create a file in sites-available for the site you're setting up:

   `sudo vim /etc/nginx/sites-available/panzerdragoonlegacy.com`

3. Paste in the following, updating the upstream app server and root paths, and
   save the file:

   ```
   upstream app {
     # Path to Unicorn SOCK file, as defined previously
     server unix:/home/panzerdragoonlegacy/panzerdragoonlegacy/current/tmp/sockets/unicorn.sock fail_timeout=0;
   }

   server {
     listen 80;
     server_name localhost;

     root /home/panzerdragoonlegacy/panzerdragoonlegacy/current/public;

     try_files $uri/index.html $uri @app;

     location @app {
         proxy_pass http://app;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header Host $http_host;
         proxy_redirect off;
     }

     error_page 500 502 503 504 /500.html;
     client_max_body_size 4G;
     keepalive_timeout 10;
   }
   ```

4. Link to the configuration in sites-enabled:

   `sudo ln -s /etc/nginx/sites-available/panzerdragoonlegacy.com /etc/nginx/sites-enabled/100-panzerdragoonlegacy.com`

5. Restart nginx:

   `sudo service nginx restart`

## Copying the Site's Data From Another Server

1. On the old server, log in as the web app user:

   `sudo su thewilloftheancients`

2. Get the password for the database from `database.yml`:

   `cat ~/thewilloftheancients/shared/config/database.yml`

3. Create a dump of the database as a tar file, pasting in the password from
   `database.yml` when prompted:

  `pg_dump thewilloftheancients > db.sql`

4. On the new server, log in as the web app user:

   `sudo su panzerdragoonlegacy`

5. Get the web app user's public key:

   `cat ~/.ssh/id_rsa.pub`

6. Back on the old server, paste the new web app user's public key into the
   `authorized_keys` file of the old web app user:

   `vim ~/.ssh/authorized_keys`

7. On the new server, copy the data files in the `system` directory from the
   old server. These must be copied at the same time as the database so that
   the record IDs remain in sync:

   `scp -r thewilloftheancients@178.62.191.241:~/thewilloftheancients/shared/public/system/* ~/panzerdragoonlegacy/shared/public/system`

8. On the new server, copy the database dump from the old server to the home
   directory of the webapp user on the new server:

   `scp thewilloftheancients@178.62.191.241:db.sql ~`

9. Get the database password on the new server:

   `cat ~/panzerdragoonlegacy/shared/config/database.yml`

10. Restore the database from the dump, pasting the password from
   `database.yml` when prompted:

   `psql -d panzerdragoonlegacy -f db.sql`

    Note: if the database was backed up as a differently named role you may
    need to temporarily create this role on the new server in order for the
    restore to succeed. E.g. as an admin with sudo access:

    `sudo -u postgres psql`

    `CREATE USER thewilloftheancients WITH ENCRYPTED PASSWORD 'PASSWORDHERE';`

    then, run the restore command as the `panzerdragoonlegacy` user. Once the
    restore has completed connect to the database:

    `\c panzerdragoonlegacy;`

    reassign the owner of the database to the new role and revoke the
    privileges of the old role:

    `REASSIGN OWNED BY thewilloftheancients TO panzerdragoonlegacy;`

    `REVOKE ALL PRIVILEGES ON DATABASE panzerdragoonlegacy FROM thewilloftheancients;`

    you'll also need to revoke the privileges of the old role from each table:

    `REVOKE ALL PRIVILEGES ON videos FROM thewilloftheancients;`

    finally, once all privileges have been removed, you can drop the old role:

    `DROP ROLE thewilloftheancients;`

    `\q`

11. Remove the database dump:

    `rm ~/db.sql`
    
