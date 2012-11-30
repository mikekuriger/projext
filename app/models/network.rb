class Network < ActiveRecord::Base
  attr_accessible :farm, :farm_id, :network, :subnetbits, :gateway, :vlan, :description, :notes
  
  has_many :ips
  belongs_to :farm
  
  validates_presence_of :network, :message => "Network must exist"
  validates_presence_of :subnetbits, :message => "Subnet bits must exist"
  validates_format_of :network,
                      :with => /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/,
                      :message => "Network must be a valid IP address"
  # Validate that the network address is actually a network address
  #validate :network_must_be_valid
  
  before_save :reset_network
  after_save :update_ips

  def netmask
    IPAdmin::CIDR.new("#{network}/#{subnetbits}").netmask_ext
  end
  
  def broadcast
    IPAdmin::CIDR.new("#{network}/#{subnetbits}").broadcast
  end
  
  # def network_must_be_valid
  #   subnetbits ||= 24
  #   errors.add :network, 'is not a valid network address.' if
  #     IPAdmin::CIDR.new("#{network}/#{subnetbits}").network != network
  # end
  
  private
  # def set_subnetbits
  #   #self.subnetbits = IPAddr.new(netmask).to_i.to_s(2).count("1")
  #   self.subnetbits = IPAdmin::CIDR.new("#{network}/#{netmask}").bits
  # end
  
  # def set_netmask
  #   self.netmask = IPAdmin::CIDR.new("#{network}/#{subnetbits}").netmask_ext
  # end
  
  # Make sure that the network address is set properly, in case an IP address within the subnet is provided
  def reset_network
    self.network = IPAdmin::CIDR.new("#{network}/#{subnetbits}").network
  end
  
  # Check all other networks to make sure there is no overlap between them and this one
  def check_for_overlap
  end
  
  # Update all IPs for a network (to reflect ownership)
  def update_ips
    Ip.find_or_create_by_ip(network).update_attributes(:network => self)
    IPAdmin.range(:Boundaries => [ network, broadcast]).each do |ip|
      Ip.find_or_create_by_ip(ip).update_attributes(:network => self)
    end
    Ip.find_or_create_by_ip(broadcast).update_attributes(:network => self)
  end
end

# == Schema Information
#
# Table name: networks
#
#  id          :integer(4)      not null, primary key
#  farm_id     :integer(4)
#  network     :string(255)
#  subnetbits  :integer(4)
#  netmask     :string(255)
#  gateway     :string(255)
#  vlan        :string(255)
#  description :string(255)
#  notes       :text
#  created_at  :datetime
#  updated_at  :datetime
#

