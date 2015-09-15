require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "thewilloftheancients"

role :web, "178.62.191.241"                # Your HTTP server, Apache/etc
role :app, "178.62.191.241"                # This may be the same as your `Web` server
role :db,  "178.62.191.241", primary: true # This is where Rails migrations will run

set :user, "thewilloftheancients"
set :deploy_to, "/home/thewilloftheancients/site"
set :use_sudo, false

set :scm, "git"
set :repository,  "https://chrisalley@github.com/chrisalley/the-will-of-the-ancients.git"
set :branch, "master"

set :rails_env, "production"
set :rvm_ruby_string, '2.2.1@thewilloftheancients' # Defaults to 'default'
set :rvm_type, :system
set :rvm_path, '/usr/local/rvm'

before "deploy:assets:precompile" do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
  run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
end

after("deploy:migrate", "deploy:build_missing_paperclip_styles")

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles, roles: :app do
    #run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake paperclip:refresh:missing_styles"
  end
end
