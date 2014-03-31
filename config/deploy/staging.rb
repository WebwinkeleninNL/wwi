
set :stage, :staging
set :rails_env, :staging
set :unicorn_rack_env, :staging

set :application, 'stage.webwinkelenin.nl'

set :rvm_type,  :system
set :rvm_ruby_version, '2.0.0-p451'
# set :rvm_roles, [:app, :web]

server "stage.webwinkelenin.nl", roles: [:web, :app, :db], user: :deploy, :primary => true

# # # Default deploy_to directory is /var/www/my_app
set :deploy_to, '/mnt/application/stage-webwinkelenin'
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid"
