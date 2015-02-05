The Will of the Ancients
========================

A custom content management system for
[thewilloftheancients.com](http://www.thewilloftheancients.com)

Installing Locally
------------------

This guide assumes that you already have Git, Ruby, RubyGems, and Bundler
installed on your development machine.

```
git clone https://github.com/chrisalley/the-will-of-the-ancients.git
cd the-will-of-the-ancients
cp config/examples/database.yml config/database.yml
cp config/examples/secrets.yml config/secrets.yml
bundle
rake db:schema:load
rails s
```

Copyright
---------

Source code and other assets in this repository are provided for demonstration
purposes only. Source code files in this repository are © 2015 Chris Alley.
