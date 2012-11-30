# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'railroad/tasks/diagrams'

# For state_machine
#require 'state_machine/tasks'

# For thinking sphinx search
require 'thinking_sphinx/tasks'

# For metric_fu
#require 'metric_fu'

desc "Run all tests and features"
task :default => [:test, :features]
