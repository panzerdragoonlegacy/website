set :application, "thewilloftheancients"
#set :repository,  "https://uriptical@github.com/uriptical/thewilloftheancients.git"
set :scm, :none
set :repository, "."
set :deploy_via, :copy

#set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/chrisalley/webapps/twota4"

role :web, "web235.webfaction.com"                          # Your HTTP server, Apache/etc
role :app, "web235.webfaction.com"                          # This may be the same as your `Web` server
role :db,  "web235.webfaction.com", :primary => true        # This is where Rails migrations will run

set :user, "chrisalley"
#set :scm_username, "uriptical"
set :use_sudo, false
default_run_options[:pty] = true

namespace :deploy do
  desc "Restart nginx"
  task :restart do
    run "#{deploy_to}/bin/restart"
  end
  
  namespace :assets do
    desc "Precompile assets on local machine and upload them to the server."
    task :precompile, roles: :web, except: {no_release: true} do
      run_locally "bundle exec rake assets:precompile RAILS_ENV=development"
      find_servers_for_task(current_task).each do |server|
        run_locally "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{server.host}:#{shared_path}/"
      end
    end
  end
end