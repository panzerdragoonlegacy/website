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

   `git clone https://github.com/panzerdragoonlegacy/website.git`

   `cd website`

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
     confirmed_at: Time.now,
   )

   exit
   ```

10. For automatic reloading of webpack-dev-server, open a seperate tab and run:

    `docker-compose exec app bash`

    `WEBPACKER_DEV_SERVER_HOST=0.0.0.0 ./bin/webpack-dev-server`

11. Open http://localhost:3000/admin to log in as the admin user.

## Restore a Database Backup into Docker Volume

1. Change into the project's directory:

   `cd ~/Code/website`

2. Stop the app (if it is running) and start the database container only.

   `docker-compose stop`

   `docker-compose start database`

3. Open psql in an interactive terminal.

   `docker exec -it website-database-1 psql -U postgres`

4. Delete any old versions of the webapp database and user (if required):

   `DROP DATABASE panzerdragoonlegacy;`

   `DROP USER panzerdragoonlegacy;`

5. Create a user and database for the webapp that matches what is in the backup:

   `CREATE USER panzerdragoonlegacy;`

   `CREATE DATABASE panzerdragoonlegacy;`

6. Give the user you created full access to the database:

   `GRANT ALL PRIVILEGES ON DATABASE panzerdragoonlegacy TO panzerdragoonlegacy;`

7. Set the owner of the database to the user:

   `ALTER DATABASE panzerdragoonlegacy OWNER TO panzerdragoonlegacy;`

8. Quit postgres:

   `\q`

9. Restore the database from a backup .sql file:

   `cat /My/Path/backup.sql | docker exec -i website-database-1 psql -U postgres -d panzerdragoonlegacy`

10. Set a password for the webapp user:

    `docker exec -it website-database-1 psql -U postgres`

    `ALTER USER panzerdragoonlegacy WITH PASSWORD 'PASSWORDHERE';`

    `\q`

11. Update `.env` with the database user, password and name you used.

    ```
    DB_USER=panzerdragoonlegacy
    POSTGRES_PASSWORD=PASSWORDHERE
    DB_NAME=panzerdragoonlegacy
    DB_HOST=database
    ```

12. Restart the containers to reload from `.env`

    `docker-compose down`

    `docker-compose up`

13. Run any outstanding migrations on the restored database

    `docker-compose exec app bin/rails db:migrate`

## Restore Paperclip Attachments into Docker Volume

1. Copy the system folder from the backup on your local machine into the volume
   (this will take a while):

   `docker cp /My/Path/system website-app-1:cms/public`

2. Change into the project's directory (if not already there):

   `cd ~/Code/website`

3. Restart the app

   `docker-compose down`

   `docker-compose up`

4. If new attachment styles have been added to the codebase since the backup was
   created you can generate these inside the container (this will take a while):

   `docker-compose exec app bash`

   `bundle exec rake paperclip:refresh:missing_styles`

5. Open http://localhost:3000 in a web browser and confirm that the complete
   website (database and file attachments) has been restored as expected.

## Running the Test Suite

1. If it does not already exist, create the test database, reusing the database
   user and password that we set up for the development database:

   `docker exec -it website-database-1 psql -U postgres`

   `DROP DATABASE panzerdragoonlegacy_test;` (if required)

   `CREATE DATABASE panzerdragoonlegacy_test;`

   `GRANT ALL PRIVILEGES ON DATABASE panzerdragoonlegacy_test TO panzerdragoonlegacy;`

   `ALTER DATABASE panzerdragoonlegacy_test OWNER TO panzerdragoonlegacy;`

   `\q`

2. Load the database schema into the test database:

   `docker-compose exec app rails db:schema:load RAILS_ENV=test`

3. Run the test suite (this will take a while):

   `docker-compose exec app bin/rspec`
