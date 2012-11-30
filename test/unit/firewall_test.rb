require 'test_helper'

class FirewallTest < ActiveSupport::TestCase
  subject { Factory(:firewall) }
  should validate_presence_of :name
  # should validate_presence_of :hostname, :message => "Firewall hostname can't be blank"
  # should validate_uniqueness_of :hostname, :scoped_to => :domain, :message => "Hostname must be unique"
end
