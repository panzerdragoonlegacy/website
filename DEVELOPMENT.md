# Development Configuration

Step-by-step instructions for setting up a development environment for the site.

## With Docker

### Setting Up the Development Environment

1. Install Docker (refer to setup instructions on docker.com)

2. Clone the git repository and change into it's directory:

   `git clone https://github.com/chrisalley/panzer-dragoon-legacy.git`

   `cd panzer-dragoon-legacy`

3. Create database.yml, secrets.yml, and .env from the example files:

   `cp config/examples/database.yml config/database.yml`

   `cp config/examples/secrets.yml config/secrets.yml`

   `cp .example.env .env`

4. Run and start the Docker containers:

   `docker-compose up -d`

5. If it does not already exist, create the development database:

   `docker-compose exec web bin/rake db:create`

6. Load the database schema and run any pending migrations:

   `docker-compose exec web bin/rake db:schema:load`

   `docker-compose exec web bin/rake db:migrate`

7. Enter the Rails console and create an administrator user:

   `docker-compose exec web bin/rails c`

   ```ruby
   User.create(
     email: 'admin@example.com',
     password: 'MyPa$$word',
     administrator: true,
     confirmed_at: Time.now
   )

   exit
   ```

8. Open http://localhost:3000 to log in as the admin user.

### Running the Test Suite

1. If it does not already exist, create the test database:

   `docker-compose exec web bin/rake db:create RAILS_ENV=test`

2. Run this test suite:

   `docker-compose exec web bin/rspec`

## Without Docker

### Set Up the Virtual Machine

These instructions are geared towards setting up the development environment in
a Debian-based virtual machine (specifically Linux Mint). Alternatively,
you may develop on another Unix-based operating system such as macOS, using
Homebrew for package management instead of APT.

1. Download Virtual Box from: https://www.virtualbox.org/wiki/Downloads

2. Download Linux Mint from: https://linuxmint.com/download.php

3. From the downloaded file, install Virtual Box. In Virtual Box, create a new
   virtual machine and install Linux Mint onto it from the ISO file. Allocate
   at least 16GB of disk space to the virtual disk.

4. Enable copying and pasting between host and guest machines by setting the
   shared clipboard to bidirectional in the virtual machine's settings under
   Machine > Settings > General > Shared Clipboard > Bidirectional. You will
   need to close and open the virtual machine for this change to be applied.

5. In the guest operating system's terminal, update apt-get:

   `sudo apt-get update`

6. Install git:

   `sudo apt-get install git`

7. Install vim:

   `sudo apt-get install vim`

8. You may also need to install a build environment:

   `sudo apt-get install build-essential`

9. Install dependencies required to install Ruby:

   `sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev`

## Set Up the Ruby Environment

1. Clone the latest version of rbenv:

   `git clone https://github.com/rbenv/rbenv.git ~/.rbenv`

2. Add rbenv to your path:

   `echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc`

   Note: on macOS, use .bash_profile instead of .bashrc

3. Initialise rbenv:

   `echo 'eval "$(rbenv init -)"' >> ~/.bashrc`

5. Install the ruby-build plugin:

   `git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build`

6. Add ruby-build to your path:

   `echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc`

7. Restart your shell by opening a new terminal tab and check that rbenv was
   set up correctly:

   `type rbenv`

   You should see:

   `rbenv is a function`

8. Install the ruby version in the app's .ruby_version file:

   `rbenv install 2.5.3`

9. Set this ruby version as the global ruby:

   `rbenv global 2.5.3`

10. Install bundler:

    `gem install bundler`

11. Install Rails:

    `gem install rails`

12. Rehash rbenv to install shims for Rails:

    `rbenv rehash`

### Install Other Rails Dependencies

1. Install nodejs (for the asset pipeline):

   `sudo apt-get install nodejs`

2. Install imagemagick (for processing image attachments):

   `sudo apt-get install imagemagick`

## Set Up PostgreSQL

1. Install PostgreSQL:

   `sudo apt-get install postgresql postgresql-contrib libpq-dev`

2. Log in to PostgreSQL:

   `sudo -u postgres psql`

   Note: on macOS you can use the user postgres with the password postgres;
   there is no need to create a new user account. Also, the database can be
   created via rake, so the remaining steps for setting up PostgreSQL can be
   skipped.

3. Create a user for the webapp:

   `CREATE USER panzerdragoonlegacy WITH ENCRYPTED PASSWORD 'PASSWORDHERE';`

4. Create databases for the development and test environments:

   `CREATE DATABASE panzerdragoonlegacy_dev;`

   `CREATE DATABASE panzerdragoonlegacy_test;`

5. Give the new user full access to the new databases:

   `GRANT ALL PRIVILEGES ON DATABASE panzerdragoonlegacy_dev TO panzerdragoonlegacy;`

   `GRANT ALL PRIVILEGES ON DATABASE panzerdragoonlegacy_test TO panzerdragoonlegacy;`

6. Set the owner of the new databases to the new user:

   `ALTER DATABASE panzerdragoonlegacy_dev OWNER TO panzerdragoonlegacy;`

   `ALTER DATABASE panzerdragoonlegacy_test OWNER TO panzerdragoonlegacy;`

7. Quit postgres:

   `\q`

### Set Up the Rails App

1. Create a Code directory and change into it:

   `mkdir ~/Code`

   `cd ~/Code`

2. Clone the app into this directory and change into it:

   `git clone https://github.com/chrisalley/panzer-dragoon-legacy.git`

   `cd panzer-dragoon-legacy`

3. Create database.yml and secrets.yml from the example files:

   `cp config/examples/database.yml config/database.yml`

   `cp config/examples/secrets.yml config/secrets.yml`

4. Download the app's gems:

   `bundle`

5. Update database.yml with the development and test database details we set
   up earlier:

   `vim config/database.yml`

   ```yaml
   development:
     adapter: postgresql
     encoding: unicode
     database: panzerdragoonlegacy_dev
     host: localhost
     username: panzerdragoonlegacy
     password: PASSWORDHERE

   test:
     adapter: postgresql
     encoding: unicode
     database: panzerdragoonlegacy_test
     host: localhost
     username: panzerdragoonlegacy
     password: PASSWORDHERE
   ```

6. Load the database schema:

   `bundle exec rake db:schema:load`

   Note: on macOS, first run `bundle exec rake db:create` to create the
   database.

7. Start the development server:

   `rails s`

8. Visit `http://localhost:3000` to view the website. If you previously
   installed a copy of the website with a different dataset you may need to
   clear your browser cookies.

### Setting Up an Admin Account in Development

1. Go to Mailtrap.io and create an account to use as a development mail server.
   Paste the API details provided by Mailtrap into secrets.yml:

   `vim config/secrets.yml`

   ```yaml
   development:
     secret_key_base: 5570409713dd4f314af9d9830a37f76c7bc212d6da38febc49df780aa2941d2ec983787f1ceb8269b208a5fd6b55435f561703503303bd03eb5d24193e004c21
     smtp_settings:
       address: mailtrap.io
       port: 2525
       user_name: MAILTRAPUSERNAMEHERE
       password: MAILTRAPPASSWORDHERE

   ```

2. Start the Rails server:

   `rails s`

3. Register an account at http://localhost:3000/register and confirm the
   account by clicking the link in the confirmation email.

4. Open Rails console:

   `rails c`

5. Set the user to be an administrator:

   `User.last.update administrator: true`

6. Exit Rails console:

   `exit`

## Publishing Code Changes

1. Before changes are committed, ensure that all automated tests are passing:

   `bin/rspec`

2. If you haven't done so already, add your name and email address to git's
   configuration:

   `git config --global user.name "Chris Alley"`

   `git config --global user.email "chris@chrisalley.info"`

3. Once code changes are ready to be published, commit and push to the master
   branch (or create a pull request if you don't have permission):

   `git add -A`

   `git commit -m "Update the website with new awesome changes"`

   `git push origin master`

4. Now deploy the changes from origin with Capistrano:

   `cap production deploy`

  You may need to manually restart the VPS for the changes to come into effect.
