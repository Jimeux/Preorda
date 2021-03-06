lock '3.4.0'

set :application, 'preorda'
set :repo_url, 'git@bitbucket.org:jimeux/launchbro.git'
set :deploy_to, "/var/www/#{fetch(:application)}"

set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'

#set :rvm_type, :user                     # Defaults to: :auto
#set :rvm_ruby_version, '2.1.3p242'      # Defaults to: 'default'
#set :rvm_custom_path,  '/usr/local/rvm'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :scm, :git

#set :deploy_via, :remote_cache # User git pull instead of clone

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :linked_files, %w{config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      #invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
