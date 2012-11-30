require 'test_helper'

class FirewallTest < ActiveSupport::TestCase
  subject { Factory(:firewall) }
  should_validate_presence_of :name, :message => "Asset name can't be blank"
  # should_validate_presence_of :hostname, :message => "Firewall hostname can't be blank"
  # should_validate_uniqueness_of :hostname, :scoped_to => :domain, :message => "Hostname must be unique"
end
