# Settings specified here will take precedence over those in config/environment.rb

# We'd like to stay as close to prod as possible
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Disable delivery errors if you bad email addresses should just be ignored
config.action_mailer.raise_delivery_errors = false

# For clearance emails
config.action_mailer.default_url_options = { :host => 'staging.wham.warnerbros.com' }
HOST = 'staging.wham.warnerbros.com'

# For exception notifications
ExceptionNotifier.exception_recipients = %w(e@wb.com)

# defaults to exception.notifier@default.com
ExceptionNotifier.sender_address =
  %("Application Error" <app.error@staging.wham.warnerbros.com>)

# defaults to "[ERROR] "
ExceptionNotifier.email_prefix = "[WHAM ERROR - STAGING] "

# Paperclip options
Paperclip.options[:command_path] = "/usr/local/bin"

