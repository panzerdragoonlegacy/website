The Will of the Ancients
========================

A custom content management system for
[thewilloftheancients.com](http://www.thewilloftheancients.com)

Installing the Project in Development
-------------------------------------

This guide assumes that you already have Git, Ruby, RubyGems, and Bundler
installed on your development machine.

You will also need to install ImageMagick for file attachments and PostgreSQL
for the database. SQLite may be used in development for simplicity.

```
git clone https://github.com/chrisalley/the-will-of-the-ancients.git
cd the-will-of-the-ancients
cp config/examples/database.yml config/database.yml
cp config/examples/secrets.yml config/secrets.yml
bundle
rake db:schema:load
rails s
```

Then visit `http://localhost:3000` to view the website. If you previously
installed a copy of the website with a different dataset you may need to clear
your browser cookies.

Setting Up an Admin Account in Development
------------------------------------------

1. Add the Mandrill username and API key to `config/secrets.yml`.
2. Start the Rails server with `rails s`.
3. Register an account at `http://localhost:3000/users/register`.
4. Open Rails console with `rails c`.
5. Set the user to be an administrator: `User.last.update administrator: true`.

Publishing Code Changes
-----------------------

Before changes are committed, ensure that all automated tests are passing:

```
rspec
```

Once code changes are ready to be published, commit and push to the master
branch (or create a pull request if you don't have permission).

```
git add -A
git commit -m "Update the website with new awesome changes"
git push origin master
```

Now deploy the changes from origin with Capistrano:

```
cap deploy
```

If there are database migrations to be applied, use:

```
cap deploy:migrations
```

Copyright
---------

Source code and other assets in this repository are provided for demonstration
purposes only. Source code files in this repository are © 2015 Chris Alley.
