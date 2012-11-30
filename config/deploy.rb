$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ree@wham-staging'        # Or whatever env you want it to run in.

# SSH options
# Enable agent forwarding so we can pull code from git
set :ssh_options, { :forward_agent => true }

set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

before "deploy:setup", "db:password"

namespace :deploy do
  desc "Default deploy - updated to run migrations"
  task :default do
    set :migrate_target, :latest
    update_code
    migrate
    symlink
    restart
  end
  desc "Start the mongrels"
  task :start do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::start --config #{mongrel_cluster_config}")
  end
  desc "Stop the mongrels"
  task :stop do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::stop --config #{mongrel_cluster_config}")
  end
  desc "Restart the mongrels"
  task :restart do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::restart --config #{mongrel_cluster_config}")
  end

  # Clean up old releases after each deployment
  after "deploy", "deploy:cleanup"

  before :deploy do
    if real_revision.empty?
      raise "The tag, revision, or branch #{revision} does not exist."
    end
  end
end

namespace :db do
  desc "Create database password in shared path" 
  task :password do
    set :db_password, Proc.new { Capistrano::CLI.password_prompt("Remote database password: ") }
    run "mkdir -p #{shared_path}/config" 
    put db_password, "#{shared_path}/config/dbpassword" 
  end
end

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :deploy do
#  task :start {}
#  task :stop {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

deploy.task :symlinks do
  run "ln -nfs #{shared_path}/assets #{release_path}/assets"
end

after 'deploy:update_code', 'deploy:symlinks' 

###
# Thinking Sphinx deployment tasks
after "deploy:restart", "deploy:search_stop"
after "deploy:restart", "deploy:search_config"
after "deploy:restart", "deploy:search_index"
after "deploy:restart", "deploy:search_start"

namespace :deploy do

  desc "Config Search"
  task :search_config, :roles => :app do
    run "cd #{current_path} && rake ts:config RAILS_ENV=#{rails_env}"
  end

  desc "Start Search"
  task :search_start, :roles => :app do
    run "cd #{current_path} && rake ts:start RAILS_ENV=#{rails_env}"
  end

  desc "Stop Search"
  task :search_stop, :roles => :app do
    run "cd #{current_path} && rake ts:stop RAILS_ENV=#{rails_env}"
  end

  desc "Rebuild Search"
  task :search_rebuild, :roles => :app do
    run "cd #{current_path} && rake ts:stop RAILS_ENV=#{rails_env}"
    run "cd #{current_path} && rake ts:config RAILS_ENV=#{rails_env}"
    run "cd #{current_path} && rake ts:index RAILS_ENV=#{rails_env}"
    run "cd #{current_path} && rake ts:start RAILS_ENV=#{rails_env}"
  end

  desc "Index Search"
  task :search_index, :roles => :app do
    run "cd #{current_path} && rake ts:in RAILS_ENV=#{rails_env}"
  end
end
###

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
