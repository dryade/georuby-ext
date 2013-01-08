source "http://rubygems.org"

# Specify your gem's dependencies in georuby-ext.gemspec
gemspec

group :development do
  gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux') && 'rb-inotify'
  gem 'libnotify', :require => RUBY_PLATFORM.include?('linux') && 'libnotify'
  gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
end