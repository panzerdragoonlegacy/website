# Development Configuration

Step-by-step instructions for setting up a development environment for the site.

## Set Up the Development Environment

1. Install git (refer to setup instructions on git-scm.com)

2. Install Docker and Docker Compose (refer to setup instructions on
   docker.com).

3. Create a 'Code' directory in your home directory if it doesn't already exist.

   `mkdir ~/Code`

4. Clone the git repository and change into it's directory:

   (Only required on Windows): `git config --global core.autocrlf false`

   `cd ~/Code`

   `git clone https://github.com/panzerdragoonlegacy/cms.git`

   `cd cms`

5. Create a .env from the example file:

   `cp .example.env .env`

6. Build and start the Docker containers:

   `docker-compose up --build`

7. If they do not already exist, create the development and test databases:

   `docker-compose exec app bin/rails db:create`

8. Load the database schema and run any pending migrations:

   `docker-compose exec app bin/rails db:schema:load`

   `docker-compose exec app bin/rails db:migrate`

9. Enter the Rails console and create an administrator user:

   `docker-compose exec app bin/rails c`

   ```ruby
   User.create(
     email: 'admin@example.com',
     password: 'MyPa$$word',
     administrator: true,
     confirmed_at: Time.now
   )

   exit
   ```

10. Open http://localhost:3000/admin to log in as the admin user.

11. For automatic reloading of webpack-dev-server, open a seperate tab and run:

    `docker-compose exec app bash`

    `WEBPACKER_DEV_SERVER_HOST=0.0.0.0 ./bin/webpack-dev-server`

## Restore a Database Backup into Docker Volume

1. Change into the project's directory:

   `cd ~/Code/cms`

2. Stop the app and start the database container only.

   `docker-compose stop`

   `docker-compose start database`

3. Open psql in an interactive terminal.

   `docker exec -it cms_database_1 psql -U postgres`

4. Create a user for the webapp that matches what is in the backup:

   `CREATE USER panzerdragoonlegacy WITH ENCRYPTED PASSWORD 'PASSWORDHERE';`

5. Create a database (drop old database first if required):

   `DROP DATABASE panzerdragoonlegacy;` (if required)

   `CREATE DATABASE panzerdragoonlegacy;`

6. Give the user you created full access to the database:

   `GRANT ALL PRIVILEGES ON DATABASE panzerdragoonlegacy TO panzerdragoonlegacy;`

7. Set the owner of the database to the user:

   `ALTER DATABASE panzerdragoonlegacy OWNER TO panzerdragoonlegacy;`

8. Quit postgres:

   `\q`

9. Restore the database from a backup .sql file:

   `cat /My/Path/backup.sql | docker exec -i cms_database_1 psql -U panzerdragoonlegacy`

10. Update `.env` with the database user, password, and name you used.

    ```
    DB_USER=panzerdragoonlegacy
    POSTGRES_PASSWORD=PASSWORDHERE
    DB_NAME=panzerdragoonlegacy
    DB_HOST=database
    ```

11. Restart the containers to reload from `.env`

    `docker-compose down`

    `docker-compose up`

12. Run any outstanding migrations on the restored database

    `docker-compose exec app bin/rails db:migrate`

## Restore Paperclip Attachments into Docker Volume

1. Copy the system folder from the backup on your local machine into the volume
   (this will take a while):

   `docker cp /My/Path/system cms_app_1:cms/public`

2. Change into the project's directory:

   `cd ~/Code/cms`

3. Restart the app

   `docker-compose down`

   `docker-compose up`

## Running the Test Suite

1. If it does not already exist, create the test database:

   `docker-compose exec app bin/rails db:create RAILS_ENV=test`

2. Run this test suite:

   `docker-compose exec app bin/rspec`
