require 'test_helper'

class IpTest < ActiveSupport::TestCase
  should have_one :site, :cluster, :customer
  should belong_to :network
  should have_many :assets, :services

  should have_one :interface
  
  should validate_presence_of :ip, :message => "IP must exist"
  
  should allow_values_for :ip, "10.1.0.0", "192.168.1.0"
  should not_allow_values_for :ip, "blah", "256.1.1.1", "10.256.0.0", "192.168.1.256", "192.168.x.y"
  
  should validate_uniqueness_of :ip, :message => "IP must be unique"
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

