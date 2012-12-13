ENV["RAILS_ENV"] ||= 'test'

require 'rspec'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'georuby-ext'
require 'georuby-ext/rspec_helper'

RSpec.configure do |c|

  c.mock_with :rspec

end

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


