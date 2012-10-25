set :application, "thewilloftheancients2"
set :repository,  "https://uriptical@github.com/uriptical/thewilloftheancients.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/chrisalley/webapps/thewilloftheancients2"

role :web, "web235.webfaction.com"                          # Your HTTP server, Apache/etc
role :app, "web235.webfaction.com"                          # This may be the same as your `Web` server
role :db,  "web235.webfaction.com", :primary => true        # This is where Rails migrations will run

set :user, "chrisalley"
set :scm_username, "uriptical"
set :use_sudo, false
default_run_options[:pty] = true

namespace :deploy do
  desc "Restart nginx"
  task :restart do
    run "#{deploy_to}/bin/restart"
  end
end