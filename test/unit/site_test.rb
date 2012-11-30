require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  should_belong_to :ip
  should_have_one :network, :through => :ip
  should_belong_to :cluster, :customer
  should_have_many :services, :through => :cluster
  should_have_many :assets, :through => :services
  
  should_validate_presence_of :name, :message => "Site name can't be blank"
  
  should_allow_values_for :name, "test.com", "www.test.com", "www.site.test.com"
  should_not_allow_values_for :name, "00:00", "blarg", "email@address.com"
end

# == Schema Information
#
# Table name: sites
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  ip_id       :integer(4)
#  vip_id      :integer(4)
#  cluster_id  :integer(4)
#  customer_id :integer(4)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

