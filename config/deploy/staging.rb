# For migrations
set :rails_env, 'staging'

set :rvm_ruby_string, 'ree@wham-staging'        # Or whatever env you want it to run in.

# Who are we?
set :application, 'wham'
set :repository, "git@git:#{application}.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :branch, "staging"

# Where to deploy to?
server "r13s03.w.warnerbros.com", :web, :app, :db, :primary => true
server "r13s04.w.warnerbros.com", :web, :app, :db

# Deploy details
#set :user, "#{application}"
set :user, "wham"
set :deploy_to, "/usr/wbol/#{application}/staging"
set :use_sudo, false
set :checkout, 'export'

# We need to know how to use mongrel
#set :mongrel_rails, '/usr/local/bin/mongrel_rails'
#set :mongrel_cluster_config, "#{deploy_to}/#{current_dir}/config/mongrel_cluster_staging.yml"
