# config valid only for current version of Capistrano
lock "3.8.0"

# config valid only for current version of Capistrano

set :application, 'lexicon'
set :repo_url, 'git@bitbucket.org:contacthrk/lexicon.git'

set :stages, %w(staging production)
set :default_stage, "staging"

set :deploy_to, '/home/deploy/lexicon'

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :bundle_binstubs, nil
# set :whenever_environment,  ->{ fetch :rails_env, "production" }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  
  desc '[internal] Updates the symlink for secrets.yml file to the just deployed release.'
  task :symlink do
    on roles :all do
      execute "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
    end
  end
  
  # desc "Update crontab with whenever"
  # task :update_cron do
  #   on roles(:app) do
  #     within current_path do
  #       execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
  #     end
  #   end
  # end
  before 'deploy:updated', "symlink"
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
