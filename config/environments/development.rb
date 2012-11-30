# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
#defaults: true for development, false for production
config.action_controller.consider_all_requests_local = false
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# For clearance emails
config.action_mailer.default_url_options = { :host => 'wham.local' }
HOST = 'localhost'

# For exception notifications
ExceptionNotifier.exception_recipients = %w(e@wb.com)

# defaults to exception.notifier@default.com
ExceptionNotifier.sender_address =
  %("Application Error" <app.error@wham.warnerbros.com>)

# defaults to "[ERROR] "
ExceptionNotifier.email_prefix = "[WHAM ERROR] "

# To set imagemagick path
Paperclip.options[:command_path] = "/usr/local/bin"
Paperclip.options[:log_command] = true
Paperclip.options[:swallow_stderr] = false

# Use memcache for caching
config.cache_store = :mem_cache_store
# Fix for memcache undefined class/module problem
require 'development/config'
