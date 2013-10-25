source "http://rubygems.org"

# Specify your gem's dependencies in georuby-ext.gemspec
gemspec

group :development do
  gem 'rb-inotify', ">= 0.9", :require => RUBY_PLATFORM.include?('linux') && 'rb-inotify'
  gem 'libnotify', ">= 0.8.0", :require => RUBY_PLATFORM.include?('linux') && 'libnotify'
  gem 'rb-fsevent', ">= 0.9.3", :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
end
