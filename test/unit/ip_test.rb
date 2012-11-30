require 'test_helper'

class IpTest < ActiveSupport::TestCase
  should_have_one :site, :cluster, :customer
  should_belong_to :network
  should_have_many :assets, :services

  should_have_one :interface
  
  should_validate_presence_of :ip, :message => "IP must exist"
  
  should_allow_values_for :ip, "10.1.0.0", "192.168.1.0"
  should_not_allow_values_for :ip, "blah", "256.1.1.1", "10.256.0.0", "192.168.1.256", "192.168.x.y"
  
  should_validate_uniqueness_of :ip, :message => "IP must be unique"
end

# == Schema Information
#
# Table name: ips
#
#  id           :integer(4)      not null, primary key
#  network_id   :integer(4)
#  ip           :string(255)
#  pingable     :boolean(1)
#  lastpinged   :datetime
#  lastresponse :datetime
#  notes        :text
#  created_at   :datetime
#  updated_at   :datetime
#

