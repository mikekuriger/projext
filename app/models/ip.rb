class Ip < ActiveRecord::Base
  attr_accessible :network, :network_id, :ip, :pingable, :lastpinged, :lastresponse, :notes
  
  has_one :site
  belongs_to :network
  has_many :assets, :through => :site
  has_one :cluster, :through => :site
  has_one :customer, :through => :site
  has_many :services, :through => :site
  
  has_one :interface
  
  validates_presence_of :ip, :message => "IP must exist"
  
  validates_format_of :ip,
                      :with => /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/,
                      :message => "IP must be a valid IP address"
  
  validates_uniqueness_of :ip, :message => "IP must be unique"
  
  def name
    ip
  end
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

