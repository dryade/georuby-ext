begin
  require 'rspec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'georuby-ext'
require 'georuby-ext/rspec_helper'

RSpec::Matchers.define :have_same do |*attributes|
  chain :than do |other|
    @other = other
  end

  match do |model|
    attributes.all? do |attribute|
      model.send(attribute) == @other.send(attribute)
    end
  end
end 
